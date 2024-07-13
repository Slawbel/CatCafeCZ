import UIKit
import SnapKit
import Cosmos

class RatingControl: UITableViewCell {
    var ratingViewCell = CosmosView()
    
    var rating = 0 {
        didSet {
            updateRating()
            delegate?.initializeRating(rating: Double(rating))
        }
    }
    
    weak var delegate: ArgumentsOfPlaceDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        ratingViewCell.settings.fillMode = .full
        ratingViewCell.settings.filledColor = .black
        ratingViewCell.settings.emptyBorderColor = .black
        ratingViewCell.settings.emptyBorderWidth = 1
        ratingViewCell.settings.starMargin = 0
        ratingViewCell.settings.starSize = 50
        
        
        ratingViewCell.didFinishTouchingCosmos = { [weak self] rating in
            self?.rating = Int(rating)
        }
        
        setupStarConstraints()
    }
    
    internal func setupStarConstraints() {
        contentView.addSubview(ratingViewCell)
        ratingViewCell.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }

    
    internal func updateRating() {
        ratingViewCell.rating = Double(rating)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
