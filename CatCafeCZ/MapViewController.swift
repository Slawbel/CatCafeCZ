import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    let map = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupMapSettings()
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
}
