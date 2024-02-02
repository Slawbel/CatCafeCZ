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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellTableViewControllerForViewController")
        
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewControllerForViewController", for: indexPath) as? CellTableViewControllerForViewController
        cell?.setup(text: "cell")
        cell?.backgroundColor = .white
        return cell!
    }

}

