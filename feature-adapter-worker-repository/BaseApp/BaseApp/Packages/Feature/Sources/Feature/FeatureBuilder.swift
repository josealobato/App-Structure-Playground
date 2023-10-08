import UIKit
import SwiftUI

/// External builder facility for the Feature.
public struct FeatureBuilder {
    
    /// Build a `Feature` feature ready to be displayed.
    /// - Returns: The View Controller of the feature to be displayed.
    public static func build(services: FeatureServiceInterface) -> UIViewController {
        
        let interactor = Interactor(services: services)
        let presenter = Presenter(interactor: interactor)
        interactor.output = presenter
        
        let view = FeatureView(presenter: presenter,
                               interactor: interactor)
        
        return UIHostingController(rootView: view)
    }
}
