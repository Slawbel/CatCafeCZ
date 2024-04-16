//
//  ViewController.swift
//  CatCafeCZ
//
//  Created by Viacheslav Belov on 01.02.2024.
//
import UIKit
import SnapKit
import RealmSwift

protocol newPlaceDelegateProtocol: AnyObject {
    func addPlace(newPlace: Cafe)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, newPlaceDelegateProtocol {
    private var tableView = UITableView()
    
    var places: Results <Cafe>!
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Cafe.self)
        
        backgroundImage.image = UIImage(named: "Photo")
        backgroundImage.contentMode = .scaleAspectFill
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellTableViewControllerForViewController.self, forCellReuseIdentifier: "CellTableViewControllerForViewController")
        tableView.backgroundColor = .black
       
        
        //self.navigationController?.changeTitleStyle()
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
        print("Setting up cell for row \(indexPath.row), name: \(place.name)")
        print(place)

        
        cell?.cellName.text = place.name
        cell?.setupLocation(textLocation: place.location)
        cell?.setupType(textType: place.type)
        
        // Если изображение может быть nil, используйте безопасное развертывание
        if let imageData = place.imageData, let image = UIImage(data: imageData) {
            cell?.cellImage.image = image
        } else {
            // Установите заглушку или другое изображение по умолчанию, если данные изображения отсутствуют
            cell?.cellImage.image = UIImage(named: "placeholder")
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
    
    @objc private func addTapped() {
        let addingNewPlace = AddingNewPlace()
        addingNewPlace.newPlaceDelegate = self
        self.navigationController?.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(addingNewPlace, animated: true)
    }
    
    internal func addPlace (newPlace: Cafe) {
        tableView.reloadData()
    }
}

extension UINavigationController {
    func setupNavigationBarTextColor() {
        self.navigationBar.tintColor = .black
    }
}
