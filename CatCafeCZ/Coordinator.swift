import UIKit

class Coordinator {
    static func openAnotherScreen(from: UIViewController, to: UIViewController) {
        to.modalPresentationStyle = .fullScreen
        from.navigationController?.pushViewController(to, animated: true)
    }
    
    static func closeAnotherScreen(from: UIViewController) {
        from.navigationController?.popViewController(animated: true)
    }
}
