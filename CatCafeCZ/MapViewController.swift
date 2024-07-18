import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController {
    let map = MKMapView()
    let closeButton = UIButton()
    let userLocationButton = UIButton()
    
    var place: Cafe = Cafe()
    let annotationIdentifier = "annotationIdentifier"
    let locationMan = CLLocationManager()
    let areaZoomSize: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        
        setupMapView()
        setupMapSettings()
        setupCloseButtonView()
        setupCloseButtonSettings()
        setupUserLocationButtonView()
        setupUserLocationButtonSettings()
        setPlace()
        checkLocationServices()
    }
    
    internal func setupMapView() {
        view.addSubview(map)
        map.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    internal func setupMapSettings() {
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsUserLocation = true
    }
    
    internal func setupCloseButtonView() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(50)
            make.top.equalTo(view).inset(100)
            make.width.height.equalTo(25)
        }
    }
    
    internal func setupCloseButtonSettings() {
        closeButton.setImage(UIImage(named: "cancelMap"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeMap), for: .touchUpInside)
    }
    
    internal func setupUserLocationButtonView() {
        view.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(50)
            make.bottom.equalTo(view).inset(70)
            make.width.height.equalTo(40)
        }
    }
    
    internal func setupUserLocationButtonSettings() {
        userLocationButton.setImage(UIImage(named: "userLocation"), for: .normal)
        userLocationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
    }
    
    @objc func showUserLocation() {
        if let location = locationMan.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: areaZoomSize, longitudinalMeters: areaZoomSize)
            map.setRegion(region, animated: true)
        }
    }
    
    internal func setPlace() {
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.map.showAnnotations([annotation], animated: true)
            self.map.selectAnnotation(annotation, animated: true)
        }
    }
    
    @objc func closeMap() {
        Coordinator.closeAnotherScreen(from: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // application of locationManager
    internal func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationMan()
            checkLocationAuthorization()
        } else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location servis is not enabled", message: "Enable location service")
            }
        }
    }
    
    // setting of locationManager
    internal func setupLocationMan() {
        locationMan.delegate = self
        locationMan.desiredAccuracy =  kCLLocationAccuracyBest
    }
    
    internal func checkLocationAuthorization() {
        switch CLLocationManager().authorizationStatus {
        case .authorizedWhenInUse:
            map.showsUserLocation = true
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Acces to your location is denied", message: "To permit: Setting -> 'This app' -> Location")
            }
            break
        case .notDetermined:
            locationMan.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    internal func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageViewForPlace = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageViewForPlace.layer.cornerRadius = 10
            imageViewForPlace.clipsToBounds = true
            imageViewForPlace.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageViewForPlace
        }
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
