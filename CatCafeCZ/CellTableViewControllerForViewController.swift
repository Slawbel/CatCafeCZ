import SnapKit
import UIKit

class CellTableViewControllerForViewController: UITableViewCell {
    var cellName = UILabel(frame: .zero)
    var cellImage = UIImageView()
    var cellLocation = UILabel(frame: .zero)
    var cellPlaceType = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellName.textAlignment = .left
        cellName.textColor = .black
        cellName.font = cellName.font.withSize(18)
        
        cellImage.contentMode = .scaleAspectFill
        cellImage.clipsToBounds = true
    
        cellLocation.textAlignment = .left
        cellLocation.textColor = .black
        cellLocation.font = cellLocation.font.withSize(15)
        cellLocation.text = "Second label"
        
        cellPlaceType.textAlignment = .left
        cellPlaceType.textColor = .black
        cellPlaceType.font = cellLocation.font.withSize(13)
        cellPlaceType.text = "Third label"
        
        contentView.addSubview(cellImage)
        contentView.addSubview(cellName)
        contentView.addSubview(cellLocation)
        contentView.addSubview(cellPlaceType)
        
        cellImage.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        cellName.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        cellLocation.snp.makeConstraints{ make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalToSuperview().inset(45)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        cellPlaceType.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalToSuperview().inset(70)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
    }
    

    func setupTitle (textName: String?) {
        cellName.text = textName
    }
    
    func setupLocation (textLocation: String?) {
        cellLocation.text = textLocation
    }
    
    func setupType (textType: String?) {
        cellPlaceType.text = textType
    }
    


    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
