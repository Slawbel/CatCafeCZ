import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController {
    let map = MKMapView()
    let closeButton = UIButton()
    
    var place: Cafe = Cafe()
    let annotationIdentifier = "annotationIdentifier"
    let locationMan = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        
        setupMapView()
        setupMapSettings()
        setupCloseButtonView()
        setupCloseButtonSettings()
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
            // show alert controller
            showAlertForNotEnabledLocationServis()
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
            showAlertForDeniedAccedToLocation()
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
    
    internal func showAlertForNotEnabledLocationServis() {
        let alertController = UIAlertController(title: "Location servis is not enabled", message: "Enable location service", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default) { (action) in
            return
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    internal func showAlertForDeniedAccedToLocation() {
        let alertController = UIAlertController(title: "Acces to your location was denied", message: "Permit access to your location manually in settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default) { (action) in
            return
        }
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
