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
    var cellImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellName.textAlignment = .left
        cellName.numberOfLines = 10
        cellName.textColor = .black

        
        cellImage.contentMode = .scaleAspectFill
        cellImage.clipsToBounds = true
    
        
        
        contentView.addSubview(cellImage)
        contentView.addSubview(cellName)
        
        cellImage.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        cellName.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
    }
    
    func setupTitle (text: String?) {
        cellName.text = text
    }
    


    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
