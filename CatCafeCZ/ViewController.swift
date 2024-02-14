//
//  ViewController.swift
//  CatCafeCZ
//
//  Created by Viacheslav Belov on 01.02.2024.
//
import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    private var tableView = UITableView()
    
    private let places = Cafe.getCafe()
    private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.places.count
    }
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewControllerForViewController", for: indexPath) as? CellTableViewControllerForViewController
        if (cell == nil) {
            cell = CellTableViewControllerForViewController.init(style: .default, reuseIdentifier: "CellTableViewControllerForViewController")
        }
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        cell?.setupTitle(textName: self.places[indexPath.row].name )
        cell?.setupLocation(textLocation: self.places[indexPath.row].location)
        cell?.setupType(textType: self.places[indexPath.row].type)
        cell?.cellImage.image = UIImage(named: places[indexPath.row].image)
        cell?.cellImage.layer.cornerRadius = 100 / 2
        cell?.cellImage.clipsToBounds = true
        
        cell?.backgroundColor = .white
        cell?.layer.cornerRadius = 50
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc private func addTapped() {
        let addingNewPlace = AddingNewPlace()
        self.navigationController?.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(addingNewPlace, animated: true)
        
        
    }
}

extension UINavigationController {
    func setupNavigationBarTextColor() {
        self.navigationBar.tintColor = .black
    }
}
