import UIKit
import SnapKit

class CustomCellName: UITableViewCell, UITextFieldDelegate {
    
    private var addNameStackView = UIStackView()
    private var addNameLabel = UILabel()
    var placeName = UITextField()
    weak var delegate: ArgumentsOfPlaceDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addNameStackView.layer.cornerRadius = 20
        addNameStackView.axis = .vertical
        
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
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: placeName.frame.height))
        placeName.leftView = leftPaddingView
        placeName.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: placeName.frame.height))
        placeName.rightView = rightPaddingView
        placeName.rightViewMode = .always
        
        placeName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            self.delegate?.initializeNameOfPlace(name: text)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeName.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}
