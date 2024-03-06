import UIKit
import SnapKit

class CustomCellName: UITableViewCell, UITextFieldDelegate {
    
    private var addNameStackView = UIStackView()
    private var addNameLabel = UILabel()
    private var placeName = UITextField()
    
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
    
}
