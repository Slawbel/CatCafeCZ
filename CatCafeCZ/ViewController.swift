import UIKit
import SnapKit
import RealmSwift

protocol AddingNewPlaceDelegate: AnyObject {
    func didAddNewPlace()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingNewPlaceDelegate {
    private var tableView = UITableView()
    let segmentedControl = UISegmentedControl(items: ["Date", "Name"])
    
    var places: Results<Cafe>!
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var ascendingSorting = true
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure content of database is loaded
        didAddNewPlace()
        
        view.backgroundColor = .black
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .white
        segmentedControl.addTarget(self, action: #selector(sortingSelection), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellTableViewControllerForViewController.self, forCellReuseIdentifier: "CellTableViewControllerForViewController")
        tableView.backgroundColor = .black
        
        self.navigationItem.title = "Select your meal"
        self.navigationController?.navigationBar.backgroundColor = .orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ChakraPetch-Regular", size: 20)!]
        self.navigationController?.navigationBar.layer.cornerRadius = 20
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AZ"), style: .plain, target: self, action: #selector(reversedSorting))
        
        view.addSubview(backgroundImage)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.sendSubviewToBack(backgroundImage)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Constraints for segmented control
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(50)
        }
        
        // Constraints for table view
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }
    }
    
    // MARK: - TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewControllerForViewController", for: indexPath) as! CellTableViewControllerForViewController
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let place = places[indexPath.row]
        
        // Setting database content to cell's elements
        cell.cellName.text = place.name
        cell.setupLocation(textLocation: place.location)
        cell.setupType(textType: place.type)
        
        // Setting template image or image from camera or album
        if let imageData = place.imageData, let image = UIImage(data: imageData) {
            cell.cellImage.image = image
        } else {
            cell.cellImage.image = UIImage(named: "imagePlaceholder")
        }
        
        cell.cellImage.layer.cornerRadius = 50
        cell.cellImage.clipsToBounds = true
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 50
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Deleting of cell
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cafeToDelete = places[indexPath.row]
            try! realm.write {
                realm.delete(cafeToDelete)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Editing of cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeForEditing = places[indexPath.row]
        let editingScreen = AddingNewPlace()
        editingScreen.currentCafe = placeForEditing
        editingScreen.delegateToUpdateTableView = self
        Coordinator.openAnotherScreen(from: self, to: editingScreen)
    }
    
    func didAddNewPlace() {
        // Reload data and update table view after the AddingNewPlace screen is dismissed
        self.places = realm.objects(Cafe.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Opening of screen to add a new place (cell) and returning entered info to main first screen
    @objc private func addTapped() {
        let addingNewPlace = AddingNewPlace()
        addingNewPlace.delegateToUpdateTableView = self
        Coordinator.openAnotherScreen(from: self, to: addingNewPlace)
    }
    
    @objc private func sortingSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @objc private func reversedSorting() {
        ascendingSorting.toggle()
        let imageName = ascendingSorting ? "AZ" : "ZA"
        if let image = UIImage(named: imageName) {
            self.navigationItem.leftBarButtonItem?.image = image
        } else {
            print("Failed to load image named: \(imageName)")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// Extension to set black color for UINavigationController text
extension UINavigationController {
    func setupNavigationBarTextColor() {
        self.navigationBar.tintColor = .black
    }
}
