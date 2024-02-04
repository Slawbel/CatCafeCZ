//
//  CellTableViewControllerForViewController.swift
//  CatCafeCZ
//
//  Created by Viacheslav Belov on 01.02.2024.
//
import SnapKit
import UIKit

class CellTableViewControllerForViewController: UITableViewCell {
    var cellName = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellName.textAlignment = .left
        cellName.numberOfLines = 10
        cellName.textColor = .black
        
        
        contentView.addSubview(cellName)
        
        cellName.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview().inset(10)
     
        }
        
    }
    
    func setup (text: String?) {
        cellName.text = text
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
