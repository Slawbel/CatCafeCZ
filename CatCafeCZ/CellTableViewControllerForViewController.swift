//
//  CellTableViewControllerForViewController.swift
//  CatCafeCZ
//
//  Created by Viacheslav Belov on 01.02.2024.
//
import SnapKit
import UIKit

class CellTableViewControllerForViewController: UITableViewCell {
    var cellName = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellName.textAlignment = .left
        cellName.numberOfLines = 10
        cellName.textColor = .black
        cellName.text = "cell"
        
        contentView.addSubview(cellName)
        
        cellName.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
    }
    
    func setup (text: String) {
        cellName.text = text
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
