import UIKit
import SnapKit

class CustomCellImage: UITableViewCell {
    
    var placeImage = UIImageView()
    let buttonMap = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        placeImage.contentMode = .scaleAspectFill
        placeImage.contentMode = .center

        contentView.addSubview(placeImage)
        
        setupButtonMapConstraints()
        setupButtonMapSettings()
        
        placeImage.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    internal func setupButtonMapConstraints() {
        contentView.addSubview(buttonMap)
        buttonMap.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.trailing.bottom.equalTo(contentView).inset(10)
        }
    }
    
    internal func setupButtonMapSettings() {
        buttonMap.setTitle("Map", for: .normal)
        buttonMap.backgroundColor = .black
        buttonMap.setTitleColor(.orange, for: .normal)
        buttonMap.layer.cornerRadius = 10
    }

    
    func setupImageByText (text: String?) {
        let pictureByText = UIImage(named: text!)
        placeImage.image = pictureByText
    }
    
    func setupImageByImage (image: UIImage) {
        placeImage.clipsToBounds = true
        placeImage.image = image
        //placeImage.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIImage {
    func scaledToFill(targetSize: CGSize) -> UIImage {
        let newSize = targetSize
        let widthRatio = newSize.width / size.width
        let heightRatio = newSize.height / size.height
        let scaleFactor = max(widthRatio, heightRatio)
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        return scaledImage
    }
}
