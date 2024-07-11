import UIKit

class CellForAddingNewPlace: UITableViewCell {
    
    static func cellForIndexPath(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return CustomCellImage()
        case 1: return CustomCellName()
        case 2: return CustomCellLocation()
        case 3: return CustomCellPlace()
        case 4: return RatingControl()
        default: return UITableViewCell()
        }
    }
}


