import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    let map = MKMapView()
    let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        setupMapView()
        setupMapSettings()
        setupCloseButtonView()
        setupCloseButtonSettings()
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
    
    @objc func closeMap() {
        Coordinator.closeAnotherScreen(from: self)
    }

}
