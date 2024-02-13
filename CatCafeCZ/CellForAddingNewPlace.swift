import UIKit
import SnapKit



class CellForAddingNewPlace: UITableViewCell {
    private var cellImage = UIImageView()
    
    private var addNameStackView = UIStackView()
    private var addNameLabel = UILabel()
    private var addNameTF = UITextField()
    
    private var addLocationStackView = UIStackView()
    private var addLocationLabel = UILabel()
    private var addLocationTF = UITextField()
    
    private var addTypeStackView = UIStackView()
    private var addTypeLabel = UILabel()
    private var addTypeTF = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        addNameStackView.layer.cornerRadius = 20
        addNameStackView.axis = .vertical
        
        self.selectionStyle = .none
        
        cellImage.contentMode = .center

        contentView.addSubview(cellImage)

        
        cellImage.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    
    func setupImage (text: String?) {
        cellImage.image = UIImage(named: text!)
    }
    
    func setuptNameCell () {
        self.addNameStackView.layer.cornerRadius = 20
        self.addNameStackView.axis = .vertical
        
        self.addNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        self.addNameLabel.text = "Name"
 
        self.addNameTF.attributedPlaceholder = NSAttributedString(string: " Enter name of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.addNameTF.backgroundColor = .black
        self.addNameTF.layer.cornerRadius = 10
        self.addNameTF.autocapitalizationType = .sentences
        self.addNameTF.returnKeyType = .done
        self.addNameTF.textColor = .white
        self.addNameTF.delegate = self

        
        contentView.addSubview(addNameStackView)
        addNameStackView.addSubview(addNameLabel)
        addNameStackView.addSubview(addNameTF)
        
        addNameStackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addNameLabel.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addNameTF.snp.makeConstraints{ make in
            make.top.equalTo(addNameLabel.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setuptLocationCell () {
        self.addLocationStackView.layer.cornerRadius = 20
        self.addLocationStackView.axis = .vertical
        
        self.addLocationLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        self.addLocationLabel.text = "Location"
 
        self.addLocationTF.attributedPlaceholder = NSAttributedString(string: " Enter location of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.addLocationTF.backgroundColor = .black
        self.addLocationTF.layer.cornerRadius = 10
        self.addLocationTF.autocapitalizationType = .sentences
        self.addLocationTF.returnKeyType = .done
        self.addLocationTF.textColor = .white
        self.addLocationTF.delegate = self
        
        contentView.addSubview(addLocationStackView)
        addLocationStackView.addSubview(addLocationLabel)
        addLocationStackView.addSubview(addLocationTF)
        
        addLocationStackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addLocationLabel.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addLocationTF.snp.makeConstraints{ make in
            make.top.equalTo(addLocationLabel.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setuptTypeCell () {
        self.addTypeStackView.layer.cornerRadius = 20
        self.addTypeStackView.axis = .vertical
        
        self.addTypeLabel.font = UIFont.systemFont(ofSize: 19, weight: .thin)
        self.addTypeLabel.text = "Type"
 
        self.addTypeTF.attributedPlaceholder = NSAttributedString(string: " Enter type of place here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        self.addTypeTF.backgroundColor = .black
        self.addTypeTF.layer.cornerRadius = 10
        self.addTypeTF.autocapitalizationType = .sentences
        self.addTypeTF.returnKeyType = .done
        self.addTypeTF.textColor = .white
        self.addTypeTF.delegate = self
        
        contentView.addSubview(addTypeStackView)
        addTypeStackView.addSubview(addTypeLabel)
        addTypeStackView.addSubview(addTypeTF)
        
        addTypeStackView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        addTypeLabel.snp.makeConstraints{ make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        addTypeTF.snp.makeConstraints{ make in
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
