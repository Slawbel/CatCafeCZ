import SnapKit
import UIKit
import Cosmos

class CellTableViewControllerForViewController: UITableViewCell {
    var cellName = UILabel(frame: .zero)
    var cellImage = UIImageView()
    var cellLocation = UILabel(frame: .zero)
    var cellPlaceType = UILabel(frame: .zero)
    var ratingView = CosmosView()

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
        
        ratingView.settings.fillMode = .full
        ratingView.settings.filledColor = .orange
        ratingView.settings.emptyBorderColor = .orange
        ratingView.settings.emptyBorderWidth = 1
        ratingView.settings.starMargin = 0
        //ratingView.rating = 5
        
        contentView.addSubview(cellImage)
        contentView.addSubview(cellName)
        contentView.addSubview(cellLocation)
        contentView.addSubview(cellPlaceType)
        contentView.addSubview(ratingView)
        
        cellImage.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        cellName.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualTo(ratingView.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        cellLocation.snp.makeConstraints{ make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalTo(cellName.snp.bottom).offset(15)
            make.trailing.lessThanOrEqualTo(ratingView.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        cellPlaceType.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(120)
            make.top.equalTo(cellLocation.snp.bottom).offset(15)
            make.trailing.lessThanOrEqualTo(ratingView.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        ratingView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(30)
            make.width.equalTo(100) // Adjust width as needed
            make.height.equalTo(30) // Adjust height as needed
        }    }
    
    
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
