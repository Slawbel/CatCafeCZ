import UIKit
import SnapKit

class CustomCellLocation: UITableViewCell, UITextFieldDelegate {
    
    let addLocationStackView = UIStackView()
    let addLocationLabel = UILabel()
    let mapButton = UIButton()
    let placeLocation = UITextField()
    weak var delegate: ArgumentsOfPlaceDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveAddress(_:)), name: NSNotification.Name("AddressNotification"), object: nil)
        
        setupStackViewConstraints()
        setupStackViewSettings()
        
        setupLabelConstraints()
        setupLabelSettings()

        setupTextFieldConstraints()
        setupTextFieldSettings()
        
        setupMapButtonConstraints()
        setupMapButtonSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackViewConstraints() {
        contentView.addSubview(addLocationStackView)
        addLocationStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setupStackViewSettings() {
        addLocationStackView.axis = .vertical
        addLocationStackView.distribution = .fill
        addLocationStackView.alignment = .fill
        addLocationStackView.spacing = 10
        addLocationStackView.layer.cornerRadius = 20
    }
    
    private func setupLabelConstraints() {
        addLocationStackView.addArrangedSubview(addLocationLabel)
        addLocationLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
    
    private func setupLabelSettings() {
        addLocationLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        addLocationLabel.text = "Location"
    }
    
    private func setupTextFieldConstraints() {
        placeLocation.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    private func setupTextFieldSettings() {
        placeLocation.attributedPlaceholder = NSAttributedString(string: " Enter location of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        placeLocation.backgroundColor = .black
        placeLocation.autocapitalizationType = .sentences
        placeLocation.returnKeyType = .done
        placeLocation.textColor = .white
        placeLocation.delegate = self
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: placeLocation.frame.height))
        placeLocation.leftView = leftPaddingView
        placeLocation.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: placeLocation.frame.height))
        placeLocation.rightView = rightPaddingView
        placeLocation.rightViewMode = .always
        
        placeLocation.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        addLocationStackView.addArrangedSubview(placeLocation)
    }
    
    private func setupMapButtonConstraints() {
        contentView.addSubview(mapButton)
        mapButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(50)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(addLocationLabel) // Adjust as needed
        }
    }
    
    private func setupMapButtonSettings() {
        mapButton.setImage(UIImage(named: "addressMapButton"), for: .normal)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }
    
    @objc func receiveAddress(_ notification: Notification) {
        if let address = notification.object as? String {
            placeLocation.text = address
            textFieldDidChange(placeLocation)
        }
    }
}
