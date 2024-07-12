import UIKit
import SnapKit

class RatingControl: UITableViewCell {
    internal let stack = UIStackView()
    
    internal var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
            delegate?.initializeRating(rating: Double(rating))
        }
    }
    
    internal var starSize: Int = 44
    internal var starCount: Int = 5
    
    weak var delegate: ArgumentsOfPlaceDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        contentView.addSubview(stack)
        
        setupStack()
        setupButtons()
    }
    
    internal func setupStack() {
        stack.spacing = 8
        constraintsStack()
    }
    
    internal func constraintsStack() {
        stack.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    internal func setupButtons() {
        for button in ratingButtons {
            stack.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Load star image
        let filledStar = UIImage(named: "filledStar")
        let emptyStar = UIImage(named: "emptyStar")
        let highlightedStar = UIImage(named: "highlightedStar")
        
        for _ in 0..<starCount {
            let button = UIButton()
            
            // set the star image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            constraintsButton(button: button)
            
            // Button action
            button.addTarget(self, action: #selector(ratingButtonPressed(button:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    
    internal func constraintsButton(button: UIButton) {
        button.snp.makeConstraints { make in
            make.height.width.equalTo(starSize)
        }
    }
    
    @objc func ratingButtonPressed(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
        updateButtonSelectionState()
    }
    
    internal func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
