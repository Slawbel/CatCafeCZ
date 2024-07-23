import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController {
    let map = MKMapView()
    let closeButton = UIButton()
    let userLocationButton = UIButton()
    let pinView = UIImageView()
    let addressLabel = UILabel()
    let buttonDone = UIButton()
    
    var place: Cafe = Cafe()
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
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
        
        setupPinViewConstraints()
        setupPinViewSettings()
        
        setupAddressLabelConstraints()
        setupAddressLabelSettings()
        
        setupButtonDoneConstraints()
        setupButtonDoneSettings()
        
        setPlace()
        checkLocationServices()
    }
    
    internal func setupMapView() {
        view.addSubview(map)
        map.snp.makeConstraints { make in
            make.edges.equalTo(view)
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
            make.top.equalTo(view).inset(80)
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
            make.bottom.equalTo(view).inset(50)
            make.width.height.equalTo(40)
        }
    }
    
    internal func setupUserLocationButtonSettings() {
        userLocationButton.setImage(UIImage(named: "userLocation"), for: .normal)
        userLocationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
    }
    
    @objc func showUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: areaZoomSize, longitudinalMeters: areaZoomSize)
            map.setRegion(region, animated: true)
        }
    }
    
    internal func setupPinViewConstraints() {
        view.addSubview(pinView)
        pinView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-20)
        }
    }
    
    internal func setupPinViewSettings() {
        pinView.image = UIImage(named: "pin")
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.contentMode = .scaleAspectFit
    }
    
    internal func setupAddressLabelConstraints() {
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(view).inset(120)
        }
    }
    
    internal func setupAddressLabelSettings() {
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFont(ofSize: 30)
        addressLabel.backgroundColor?.withAlphaComponent(0)
        addressLabel.textAlignment = .center
    }
    
    internal func setupButtonDoneConstraints() {
        view.addSubview(buttonDone)
        buttonDone.snp.makeConstraints { make in
            make.bottom.equalTo(view).inset(50)
            make.width.greaterThanOrEqualTo(120)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
    }
    
    internal func setupButtonDoneSettings() {
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.setTitleColor(.white, for: .normal)
        buttonDone.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        buttonDone.backgroundColor?.withAlphaComponent(0)
        buttonDone.addTarget(self, action: #selector(chooseAddress), for: .touchUpInside)
    }
    
    @objc func chooseAddress() {
        // Implement your logic for when the "Done" button is pressed
    }
    
    internal func setPlace() {
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            let annotation = MKPointAnnotation()
            annotation.title = self?.place.name
            annotation.subtitle = self?.place.type
            
            guard let placemarkLocation = placemark.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self?.map.showAnnotations([annotation], animated: true)
            self?.map.selectAnnotation(annotation, animated: true)
        }
    }
    
    @objc func closeMap() {
        Coordinator.closeAnotherScreen(from: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    internal func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location service is not enabled", message: "Enable location service")
            }
        }
    }
    
    internal func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    internal func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            map.showsUserLocation = true
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
    
    private func getCenterAddress(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    internal func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterAddress(for: mapView)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            let streetName = placemark.thoroughfare
            let buildingNumber = placemark.subThoroughfare
            DispatchQueue.main.async {
                if let streetName = streetName, let buildingNumber = buildingNumber {
                    self?.addressLabel.text = "\(streetName), \(buildingNumber)"
                } else if let streetName = streetName {
                    self?.addressLabel.text = streetName
                } else {
                    self?.addressLabel.text = ""
                }
            }
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
