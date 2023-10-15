import SwiftUI

/// **Process:** Steps to add a new feature:
///
/// 1. Add the feature on the `Feature` enumeration
/// 2. Add a case in the switch found in `coordinate(from:request:)` that will call the method in step 3.
/// 3. Create a `on<Feauture>(request:)` method to handle all request for this new feature.
/// 4. On `CoordinatorRequest` add the new feauture to be able to requested in other views.
/// 

enum Feature: String, Identifiable {
    case parent
    case firstChild
    case secondChild
    case creator
    
    var id: String { self.rawValue }
}

final class AppFlowCoordinator: ObservableObject, CoordinatorRequestProtocol {
    
    // MARK: - CoordinatorRequestProtocol
   
    func coordinate(from feature: any View.Type, request: CoordinatorRequest) {
        
    }
}
