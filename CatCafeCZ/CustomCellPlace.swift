import UIKit
import SnapKit

class CustomCellPlace: UITableViewCell, UITextFieldDelegate {
    
    private var addTypeStackView = UIStackView()
    private var addTypeLabel = UILabel()
    private var placeType = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
