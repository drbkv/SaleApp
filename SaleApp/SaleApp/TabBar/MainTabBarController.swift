//import UIKit
//
//class MainTabBarController: UITabBarController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//      
//       
//        let myProfileVC = MyProfileViewController()
//        let myProfileNavigationController = UINavigationController(rootViewController: myProfileVC)
//        myProfileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
//     
//        let adTecheVC = AddTechItemViewController()
//        let addTechItemViewController = UINavigationController(rootViewController: adTecheVC)
//        addTechItemViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
//     
//        let allViewVC = AllTechItemViewController()
//        let allTechItemViewController = UINavigationController(rootViewController: allViewVC)
//        allTechItemViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
//     
//        let userViewVC = UserTechItemViewController()
//        let userTechItemViewController = UINavigationController(rootViewController: userViewVC)
//        userTechItemViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
//     
//        
//        
//        viewControllers = [ myProfileNavigationController,addTechItemViewController,allTechItemViewController,userTechItemViewController]
//    }
//}


import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let myProfileVC = MyProfileViewController()
        let myProfileNavigationController = UINavigationController(rootViewController: myProfileVC)
        myProfileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)
     
        let addTechVC = AddTechItemViewController()
        let addTechNavigationController = UINavigationController(rootViewController: addTechVC)
        addTechNavigationController.tabBarItem = UITabBarItem(title: "Add Tech", image: UIImage(systemName: "plus.circle"), tag: 1)
     
        let allTechVC = AllTechItemViewController()
        let allTechNavigationController = UINavigationController(rootViewController: allTechVC)
        allTechNavigationController.tabBarItem = UITabBarItem(title: "All Tech", image: UIImage(systemName: "list.bullet"), tag: 2)
     
        let userTechVC = UserTechItemViewController()
        let userTechNavigationController = UINavigationController(rootViewController: userTechVC)
        userTechNavigationController.tabBarItem = UITabBarItem(title: "My Tech", image: UIImage(systemName: "square.and.pencil"), tag: 3)
        
        viewControllers = [ addTechNavigationController, allTechNavigationController, userTechNavigationController,myProfileNavigationController,]
    }
}
