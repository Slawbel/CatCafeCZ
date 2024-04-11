import RealmSwift

let realm = try! Realm()

class StoreManager {
    
    static func saveObject(_ cafe: Cafe) {
        try! realm.write{
            realm.add(cafe)
        }
    }
    
}
