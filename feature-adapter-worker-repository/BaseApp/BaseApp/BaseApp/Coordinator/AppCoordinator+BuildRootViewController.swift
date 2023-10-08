import UIKit
import Coordinator
import Feature
import UsersCollection

// In this extension we build the RootViewController. In this case theRVC
// is a UITabBarController with several tabs and a feature on every tab.
extension AppCoordinator {
    
    func buildRootViewController() -> UIViewController? {
        
        guard rootViewController == nil else { return rootViewController }
        
        // Prepare the tabs
        
        let tab01Coordinator = BaseFlowCoordinator(managersTypeMapping: coordinatorManagersMapping)
        let tab01VC = buildTab01Content(coordiantor: tab01Coordinator)
        tab01Coordinator.navigationController = tab01VC
        tab01Coordinator.parentCoordinator = self
        childCoordinators.append(tab01Coordinator)
        
        let tab02Coordinator = BaseFlowCoordinator(managersTypeMapping: coordinatorManagersMapping)
        let tab02VC = buildTab02Content(coordiantor: tab02Coordinator)
//        tab02Coordinator.navigationController = tab02VC  // Not a navigsation yet
        tab02Coordinator.parentCoordinator = self
        childCoordinators.append(tab02Coordinator)
        
        // Build the tab bar VC.
        let tabVC = UITabBarController()
        tabVC.viewControllers = [tab01VC, tab02VC]
        tabVC.selectedIndex = 0

        rootViewController = tabVC
        return rootViewController
    }
    
    private func buildTab01Content(coordiantor: CoordinationRequestProtocol) -> UINavigationController {
        
        let featureVC = UsersCollectionBuilder.build(services: UsersCollectionAdaptor())
        featureVC.tabBarItem.image = UIImage(systemName: "person.3.fill")
        featureVC.tabBarItem.title = "Users"
        
        let listNavigation = UINavigationController()
        listNavigation.navigationBar.prefersLargeTitles = true
        listNavigation.pushViewController(featureVC, animated: false)
        
        return listNavigation
    }
    
    private func buildTab02Content(coordiantor: CoordinationRequestProtocol) -> UIViewController {
        
        let featureVC = FeatureBuilder.build(services: FeatureAdaptor())
        featureVC.tabBarItem.image = UIImage(systemName: "books.vertical")
        featureVC.tabBarItem.title = "Feature 2"
        
        return featureVC
    }
}
