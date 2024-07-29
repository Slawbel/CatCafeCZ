import UIKit
import MapKit
import SnapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let map = MKMapView()
    let closeButton = UIButton()
    let userLocationButton = UIButton()
    let pinView = UIImageView()
    let addressLabel = UILabel()
    let buttonDone = UIButton()
    let buttonDirection = UIButton()
    
    let mapSettings = MapSettings()
    var place: Cafe = Cafe()
    let annotationIdentifier = "annotationIdentifier"
    var activityIndicator: UIActivityIndicatorView?
    
    // Declare locationManager property
    let locationManager = CLLocationManager()

    var previousLocation: CLLocation? {
        didSet {
            mapSettings.startTracking(map: map, location: previousLocation) { [weak self] currentLocation in
                self?.previousLocation = currentLocation
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.mapSettings.showUserLocation(map: self?.map ?? MKMapView())
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        
        setupMapView()
        mapSettings.setPlace(place: place, map: map)
        setupMapSettings()
        setupLocationManager() // Ensure this is called here

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
        
        setupButtonDirectionConstraints()
        setupButtonDirectionSettings()
    }
    
    private func setupMapView() {
        view.addSubview(map)
        map.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setupMapSettings() {
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsUserLocation = true
    }
    
    private func setupCloseButtonView() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(50)
            make.top.equalTo(view).inset(80)
            make.width.height.equalTo(25)
        }
    }
    
    private func setupCloseButtonSettings() {
        closeButton.setImage(UIImage(named: "cancelMap"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeMap), for: .touchUpInside)
    }
    
    private func setupUserLocationButtonView() {
        view.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(50)
            make.bottom.equalTo(view).inset(50)
            make.width.height.equalTo(50)
        }
    }
    
    private func setupUserLocationButtonSettings() {
        userLocationButton.setImage(UIImage(named: "userLocation"), for: .normal)
        userLocationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
    }
    
    private func setupPinViewConstraints() {
        view.addSubview(pinView)
        pinView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-20)
        }
    }
    
    private func setupPinViewSettings() {
        pinView.image = UIImage(named: "pin")
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.contentMode = .scaleAspectFit
    }
    
    private func setupAddressLabelConstraints() {
        view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(view).inset(120)
        }
    }
    
    private func setupAddressLabelSettings() {
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFont(ofSize: 30)
        addressLabel.backgroundColor = .clear
        addressLabel.textAlignment = .center
    }
    
    private func setupButtonDoneConstraints() {
        view.addSubview(buttonDone)
        buttonDone.snp.makeConstraints { make in
            make.bottom.equalTo(view).inset(50)
            make.width.greaterThanOrEqualTo(120)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
    }
    
    private func setupButtonDoneSettings() {
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.setTitleColor(.black, for: .normal)
        buttonDone.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        buttonDone.backgroundColor = .clear
        buttonDone.addTarget(self, action: #selector(chooseAddress), for: .touchUpInside)
    }
    
    private func setupButtonDirectionConstraints() {
        view.addSubview(buttonDirection)
        buttonDirection.snp.makeConstraints { make in
            make.bottom.equalTo(buttonDone.snp.top).offset(-20)
            make.height.width.equalTo(50)
            make.centerX.equalTo(view)
        }
    }
    
    private func setupButtonDirectionSettings() {
        buttonDirection.setImage(UIImage(named: "GetDirection"), for: .normal)
        buttonDirection.addTarget(self, action: #selector(getDirection), for: .touchUpInside)
    }
    
    @objc private func chooseAddress() {
        NotificationCenter.default.post(name: NSNotification.Name("AddressNotification"), object: addressLabel.text)
        closeMap()
    }
    
    @objc private func closeMap() {
        Coordinator.closeAnotherScreen(from: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        mapSettings.locationManager = locationManager
        mapSettings.checkLocationAuthorization(map: map)
    }
    
    private func getCenterAddress(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    internal func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterAddress(for: mapView)
        let geocoder = CLGeocoder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.previousLocation = center
        }
        
        geocoder.cancelGeocode()
        
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

    @objc private func showUserLocation() {
        mapSettings.showUserLocation(map: map)
    }
    
    @objc private func getDirection() {
        mapSettings.getDirection(map: map) { [weak self] location in
            self?.previousLocation = location
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routeOverlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routeOverlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
