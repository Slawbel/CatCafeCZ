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
    
    
    private var restaurantNames = ["Isai Ramen", "Na kopečku", "Vavřinové lázně"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellTableViewControllerForViewController.self, forCellReuseIdentifier: "CellTableViewControllerForViewController")
        tableView.backgroundColor = .black
       
        
        //self.navigationController?.changeTitleStyle()
        self.navigationItem.title = "Select your meal"
        self.navigationController?.navigationBar.backgroundColor = .orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "ChakraPetch-Regular", size: 20)!]
        self.navigationController?.navigationBar.layer.cornerRadius = 20
        
    
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
            make.top.equalTo(view)
        }
        
    }

    // MARK: - tableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantNames.count
    }
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewControllerForViewController", for: indexPath) as? CellTableViewControllerForViewController
        if (cell == nil) {
            cell = CellTableViewControllerForViewController.init(style: .default, reuseIdentifier: "CellTableViewControllerForViewController")
        }
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        cell?.setupTitle(text: self.restaurantNames[indexPath.row] )
        
        cell?.cellImage.image = UIImage(named: restaurantNames[indexPath.row])
        cell?.cellImage.layer.cornerRadius = 100 / 2
        cell?.cellImage.clipsToBounds = true
        
        cell?.backgroundColor = .white
        cell?.layer.cornerRadius = 50
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

