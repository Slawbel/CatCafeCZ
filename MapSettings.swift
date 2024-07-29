import UIKit
import MapKit

class MapSettings {
    
    var locationManager = CLLocationManager()
    private let areaZoomSize: Double = 1000
    private var directionsArray: [MKDirections] = []
    private var placeCoordinate: CLLocationCoordinate2D?
    
    func setPlace(place: Cafe, map: MKMapView) {
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self?.placeCoordinate = placemarkLocation.coordinate
            map.showAnnotations([annotation], animated: true)
            map.selectAnnotation(annotation, animated: true)
        }
    }
    
    func checkLocationAuthorization(map: MKMapView) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            map.showsUserLocation = true
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.showAlert(title: "Access to your location is denied", message: "To permit: Settings -> 'This app' -> Location")
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    @objc func showUserLocation(map: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: areaZoomSize, longitudinalMeters: areaZoomSize)
            map.setRegion(region, animated: true)
        }
    }
    
    func getDirection(map: MKMapView, previousLocation: @escaping (CLLocation) -> ()) {
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location isn't found")
            return
        }

        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))

        guard let destinationCoordinate = placeCoordinate else {
            showAlert(title: "Error", message: "Destination isn't found")
            return
        }
        
        let startLocation = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true

        let directions = MKDirections(request: request)
        
        // Remove any existing overlays
        map.removeOverlays(map.overlays)
        
        directions.calculate { (response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                guard let response = response else {
                    self.showAlert(title: "Error", message: "Directions not available")
                    return
                }
                
                // Add route overlays
                for route in response.routes {
                    map.addOverlay(route.polyline)
                    map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
    }
    
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = placeCoordinate else { return nil }
        let startLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
    
    func startTracking(map: MKMapView, location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
        guard let location = location else { return }
        let center = getCenterAddress(map: map)
        guard center.distance(from: location) > 50 else { return }
        
        closure(center)
    }
    
    private func resetMapView(withNew directions: MKDirections, map: MKMapView) {
        map.removeOverlays(map.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    private func getCenterAddress(map: MKMapView) -> CLLocation {
        let latitude = map.centerCoordinate.latitude
        let longitude = map.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("No connected window scene found")
            return
        }
        
        let alertWindow = UIWindow(windowScene: windowScene)
        alertWindow.frame = windowScene.coordinateSpace.bounds
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true)
    }
}
