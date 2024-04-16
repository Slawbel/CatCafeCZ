import RealmSwift

let realm = try! Realm()

class StoreManager {
    
    static func saveObject(_ cafe: Cafe) {
        try! realm.write{
            realm.add(cafe)
        }
    }
    
    static func deleteObject(_ cafe: Cafe) {
        try! realm.write{
            realm.delete(cafe)
        }
    }
    
}
