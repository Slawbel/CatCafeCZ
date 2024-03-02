import UIKit


struct Cafe {
    var name: String
    var location: String?
    var type: String?
    var restaurantImage: String?
    var image: UIImage?
    
    static var restaurantNames = ["Isai Ramen", "Na kopečku", "Vavřinové lázně"]

    static func getCafe () -> [Cafe] {
        var cafes = [Cafe]()
        
        for cafe in restaurantNames {
            cafes.append(Cafe(name: cafe, location: "Czech Republic", type: "Restaurant", restaurantImage: cafe, image: nil))
        }
        
        return cafes
    }
}
