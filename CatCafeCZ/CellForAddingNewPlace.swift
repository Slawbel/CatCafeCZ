import UIKit
import SnapKit

protocol AddingNewPlaceDelegate: AnyObject {
    func setupImageByImage(image: UIImage)
}

class CellForAddingNewPlace: UITableViewCell {
    private var placeImage = UIImageView()
    
    private var addNameStackView = UIStackView()
    private var addNameLabel = UILabel()
    private var placeName = UITextField()
    
    private var addLocationStackView = UIStackView()
    private var addLocationLabel = UILabel()
    private var placeLocation = UITextField()
    
    private var addTypeStackView = UIStackView()
    private var addTypeLabel = UILabel()
    private var placeType = UITextField()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        addNameStackView.layer.cornerRadius = 20
        addNameStackView.axis = .vertical
        
        self.selectionStyle = .none
        
        placeImage.contentMode = .center

        contentView.addSubview(placeImage)

        
        placeImage.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    
    func setupImageByText (text: String?) {
        placeImage.image = UIImage(named: text!)
    }
    
    func setupImageByImage (image: UIImage) {
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        placeImage.image = image
        placeImage.layer.cornerRadius = 20
    }
    
    func setuptNameCell () {
        self.addNameStackView.layer.cornerRadius = 20
        self.addNameStackView.axis = .vertical
        
        self.addNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        self.addNameLabel.text = "Name"
 
        self.placeName.attributedPlaceholder = NSAttributedString(string: " Enter name of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.placeName.backgroundColor = .black
        self.placeName.layer.cornerRadius = 10
        self.placeName.autocapitalizationType = .sentences
        self.placeName.returnKeyType = .done
        self.placeName.textColor = .white
        self.placeName.delegate = self

        
        contentView.addSubview(addNameStackView)
        addNameStackView.addSubview(addNameLabel)
        addNameStackView.addSubview(placeName)
        
        addNameStackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addNameLabel.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        placeName.snp.makeConstraints{ make in
            make.top.equalTo(addNameLabel.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setuptLocationCell () {
        self.addLocationStackView.layer.cornerRadius = 20
        self.addLocationStackView.axis = .vertical
        
        self.addLocationLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        self.addLocationLabel.text = "Location"
 
        self.placeLocation.attributedPlaceholder = NSAttributedString(string: " Enter location of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.placeLocation.backgroundColor = .black
        self.placeLocation.layer.cornerRadius = 10
        self.placeLocation.autocapitalizationType = .sentences
        self.placeLocation.returnKeyType = .done
        self.placeLocation.textColor = .white
        self.placeLocation.delegate = self
        
        contentView.addSubview(addLocationStackView)
        addLocationStackView.addSubview(addLocationLabel)
        addLocationStackView.addSubview(placeLocation)
        
        addLocationStackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addLocationLabel.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        placeLocation.snp.makeConstraints{ make in
            make.top.equalTo(addLocationLabel.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setuptTypeCell () {
        self.addTypeStackView.layer.cornerRadius = 20
        self.addTypeStackView.axis = .vertical
        
        self.addTypeLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        self.addTypeLabel.text = "Type"
 
        self.placeType.attributedPlaceholder = NSAttributedString(string: " Enter type of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.placeType.backgroundColor = .black
        self.placeType.layer.cornerRadius = 10
        self.placeType.autocapitalizationType = .sentences
        self.placeType.returnKeyType = .done
        self.placeType.textColor = .white
        self.placeType.delegate = self
        
        contentView.addSubview(addTypeStackView)
        addTypeStackView.addSubview(addTypeLabel)
        addTypeStackView.addSubview(placeType)
        
        addTypeStackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addTypeLabel.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        placeType.snp.makeConstraints{ make in
            make.top.equalTo(addTypeLabel.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CellForAddingNewPlace: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
