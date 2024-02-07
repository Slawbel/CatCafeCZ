import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ViewController()
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.setupNavigationBarTextColor()
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }


}

