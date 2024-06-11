//
//  ViewController.swift
//  CatCafeCZ
//
//  Created by Viacheslav Belov on 01.02.2024.
//
import UIKit
import SnapKit
import RealmSwift

protocol AddingNewPlaceDelegate: AnyObject {
    func didAddNewPlace()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddingNewPlaceDelegate {
    private var tableView = UITableView()
    
    var places: Results <Cafe>!
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // here is content of database in array form
        didAddNewPlace()
        
        backgroundImage.image = UIImage(named: "Photo")
        backgroundImage.contentMode = .scaleAspectFill
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellTableViewControllerForViewController.self, forCellReuseIdentifier: "CellTableViewControllerForViewController")
        tableView.backgroundColor = .black
       
        self.navigationItem.title = "Select your meal"
        self.navigationController?.navigationBar.backgroundColor = .orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ChakraPetch-Regular", size: 20)!]
        self.navigationController?.navigationBar.layer.cornerRadius = 20

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        
        view.addSubview(backgroundImage)
        view.addSubview(tableView)
        view.sendSubviewToBack(backgroundImage)
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(view)
        }
    }

    
    // MARK: - tableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewControllerForViewController", for: indexPath) as? CellTableViewControllerForViewController
        if cell == nil {
            cell = CellTableViewControllerForViewController.init(style: .default, reuseIdentifier: "CellTableViewControllerForViewController")
        }
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let place = places[indexPath.row]
        
        // setting of database content to cell's elements
        cell?.cellName.text = place.name
        cell?.setupLocation(textLocation: place.location)
        cell?.setupType(textType: place.type)
        
        // setting of template image or image from camera or album
        if let imageData = place.imageData, let image = UIImage(data: imageData) {
            cell?.cellImage.image = image
        } else {
            cell?.cellImage.image = UIImage(named: "imagePlaceholder")
        }
        
        cell?.cellImage.layer.cornerRadius = 50
        cell?.cellImage.clipsToBounds = true
        
        cell?.backgroundColor = .white
        cell?.layer.cornerRadius = 50
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    // MARK: - deleting of cell
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cafeToDelete = places[indexPath.row]
            do {
                StoreManager.deleteObject(cafeToDelete)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - editing of cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let placeForEditing = places[indexPath.row]
        let editingScreen = AddingNewPlace()
        editingScreen.currentCafe = placeForEditing
        editingScreen.delegateToUpdateTableView = self
        Coordinator.openAnotherScreen(from: self, to: editingScreen)
    }
    
    func didAddNewPlace() {
            // Reload data and update table view after the AddingNewPlace screen is dismissed
            self.places = realm.objects(Cafe.self)
            self.tableView.reloadData()
    }
    
    
    // MARK: - Opening of screen to add some new place (cell) and returning entered info to main first screen
    @objc private func addTapped() {
        let addingNewPlace = AddingNewPlace()
        addingNewPlace.delegateToUpdateTableView = self
        Coordinator.openAnotherScreen(from: self, to: addingNewPlace)
    }

}

// needed to set black colour of text for UINavigationController
extension UINavigationController {
    func setupNavigationBarTextColor() {
        self.navigationBar.tintColor = .black
    }
}


