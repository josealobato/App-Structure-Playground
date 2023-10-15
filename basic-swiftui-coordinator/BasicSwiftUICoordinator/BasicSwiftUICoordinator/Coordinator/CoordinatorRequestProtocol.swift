import SwiftUI

/// Here we declare all possible request that the Features can do.
///
/// All features can request any a action but the coordinator is responsible of
/// handling them. If a Feature perform a request that the coordinator does not allow
/// for that feature, nothing will happen.
///
/// **NOTE:** In reality this is not a optimal way of doing this. Imaging the situation
/// in which you have 100 Features and every feature in package (SPM). Then you need to share
/// this Enum somehow with all those features. You do that with another package just with the
/// protocol, but on every new feature you will need to edit that package. One, not very popular
/// solutio, was depicted by Bruno Rocha in a talk about the Spotify architecture
/// (https://www.youtube.com/watch?v=sZuI6z8qSmc). It is using the `request` as a plain text instead
/// of an enum. Of course that might fail but I do not see that like an issue since the coordinator
/// will do nothing if the string does not exist.
enum CoordinatorRequest: String {
    case parent
    case firstChild
    case secondChild
    case backToRoot
    case creator
    
    case dismiss
}

/// This protocol will be known by all features and used to request coordinator action.
protocol CoordinatorRequestProtocol {
    
    /// Request a coordinator action.
    /// - Parameters:
    ///   - feature: The Feature should identify itself with its main View Type.
    ///             **NOTE:** Using the `View.Type` can be a problems since there could be features
    ///              without view.
    ///   - request: The resquest. See NOTE above.
    func coordinate(from feature: any View.Type , request: CoordinatorRequest)
}
