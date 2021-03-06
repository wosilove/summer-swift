import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        self.delegate = self
    }
    
    // fix for tapping the tab bar does not show the root view
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let splitViewController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? GlobalSplitViewController
        if let navController = splitViewController?.viewControllers[0] as? UINavigationController {
            navController.popViewController(animated: true)
        }
        if tabBarController.selectedIndex != 0 {
            splitViewController?.preferredDisplayMode = .allVisible
        }
    }
}
