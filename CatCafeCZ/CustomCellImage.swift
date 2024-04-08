import UIKit
import SnapKit

class CustomCellImage: UITableViewCell {
    
    var placeImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        placeImage.contentMode = .center

        contentView.addSubview(placeImage)
        
        placeImage.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func setupImageByText (text: String?) -> UIImage {
        let pictureByText = UIImage(named: text!)
        placeImage.image = pictureByText
        return pictureByText!
    }
    
    func setupImageByImage (image: UIImage) {
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        placeImage.image = image
        placeImage.layer.cornerRadius = 20
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
