import UIKit
import SnapKit

class CustomCellLocation: UITableViewCell, UITextFieldDelegate {
    
    private var addLocationStackView = UIStackView()
    private var addLocationLabel = UILabel()
    var placeLocation = UITextField()
    weak var delegate: ArgumentsOfPlaceDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        placeLocation.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            self.delegate?.initializeLocationOfPlace(location: text)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeLocation.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}
