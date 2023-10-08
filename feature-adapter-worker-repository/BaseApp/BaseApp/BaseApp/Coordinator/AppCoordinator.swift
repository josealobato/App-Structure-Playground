import UIKit
import Coordinator

class AppCoordinator: BaseFlowCoordinator {
    
    static var shared = AppCoordinator()
    
    var childCoordinators: [FlowCoordinator] = []
    
    // MARK: - Coordination
    
    override func start() {
        
        super.start()
    }
    
    override func coordinate(from module: Coordinated, request: CoordinationRequest) {
        //log.debug("Coordinate from module \(module), request: \(request)")

        // The logged in coordinator is a variation of a regular flow Controller.
        // Whilsh a regular flow controller has navigation this one has a tab controller.
        // It does not redirect unmapped actions to the parent but to the current tab
        // cooordinator.
        if managersTypeMapping[request.name] != nil {

            super.coordinate(from: module, request: request)
        } else {

            Task { @MainActor in

                self.currentSubCoordinator()?.coordinate(from: module, request: request)
            }
        }
    }
    
    /// Allows access to the current subcoordinator.
    ///
    /// This coordinator coordinates a tab controller with a flowController on every tab.
    /// And, needs to dispatch unhandled request to the current one.
    private func currentSubCoordinator() -> FlowCoordinator? {

        let currentNavigationController = currentNavigationController()
        let currentSubcoordinator = childCoordinators.first { coordinator in
            coordinator.navigationController == currentNavigationController
        }
        return currentSubcoordinator
    }

    private func currentNavigationController() -> UINavigationController? {

        if let tabViewController = rootViewController as? UITabBarController {

            return tabViewController.selectedViewController as? UINavigationController
        }

        return nil
    }
}
