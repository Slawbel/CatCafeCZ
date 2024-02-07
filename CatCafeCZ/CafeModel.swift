import Foundation


struct Cafe {
    var name: String
    var location: String
    var type: String
    var image: String
    
    static var restaurantNames = ["Isai Ramen", "Na kopečku", "Vavřinové lázně"]

    static func getCafe () -> [Cafe] {
        var cafes = [Cafe]()
        
        for cafe in restaurantNames {
            cafes.append(Cafe(name: cafe, location: "Czech Republic", type: "Restaurant", image: cafe))
        }
        
        return cafes
    }
}
