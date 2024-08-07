import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // check in case if migration is needed
        let schemaVersion: UInt64 = 4
        
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < schemaVersion {
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        // check of functional Realm database
        do {
            _ = try Realm()
        } catch {
            print("Failed to open Realm: \(error)")
        }
        
        let viewController = ViewController()
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.setupNavigationBarTextColor()
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }


}

