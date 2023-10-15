import SwiftUI

/// **Process:** Steps to add a new feature:
///
/// 1. Add the feature on the `Feature` enumeration
/// 2. Add a case in the switch found in `coordiinate(from:request:)` that will call the method in step 3.
/// 3. Create a `on<Feauture>(request:)` method to handle all request for this new feature.
/// 4. On `CoordinatorRequest` add the new feauture to be able to requested in other views.
///

final class FlowTwoCoordinator: ObservableObject, CoordinatorRequestProtocol {

    // The AppFlowCoordinator controls a navigation flow so, in this case we are
    // going to us a path
    @Published var path = NavigationPath()
    @Published var sheet: Feature?
    @Published var screenCover: Feature?
    
    // MARK: Private actions
    
    private func push(_ page: Feature) { path.append(page) }
    private func present(sheet: Feature) { self.sheet = sheet }
    private func present(screenCover: Feature) { self.screenCover = screenCover }
    private func dismissSheet() { sheet = nil; screenCover = nil}
    private func dismissScreenCover() { screenCover = nil }
    private func backToRoot() { path.removeLast(path.count) }
    
    // MARK: - CoordinatorRequestProtocol
   
    func coordinate(from feature: any View.Type, request: CoordinatorRequest) {
        
        // The coordinator knows about all the view types it controls.
        // Every view types could do different requests and the coordinator is
        // in charge of doing that coordination.
        
        switch feature {
        case is ParentView.Type: onParentView(request: request)
        case is FirstChildView.Type: onFirstChildView(request: request)
        case is SecondChildView.Type: onSecondChildView(request: request)
        case is CreatorView.Type: onCreatorView(request: request)
        default:
            print("Unknown coordinate request")
        }
    }
    
    // MARK: - Views Request Management
    
    // Every feature could do different request.
    // Here the coordinator decides what every request should do.
    // The Feature itself just request an action, but how it is handled
    // is coordinator's responsibility.
    
    func onParentView(request: CoordinatorRequest) {
        switch request {
        case .firstChild: push(Feature.firstChild)
        case .backToRoot: backToRoot()
        default: print("Request not accepted on ParentView ")
        }
    }
    
    func onFirstChildView(request: CoordinatorRequest) {
        switch request {
        case .secondChild: push(Feature.secondChild)
        case .creator: present(sheet: Feature.creator)
        case .backToRoot: backToRoot()
        default: print("Request not accepted on ParentView ")
        }
    }
    
    func onSecondChildView(request: CoordinatorRequest) {
        switch request {
        case .creator: present(screenCover: Feature.creator)
        case .backToRoot: backToRoot()
        default: print("Request not accepted on ParentView ")
        }
    }
    
    func onCreatorView(request: CoordinatorRequest) {
        switch request {
        case .dismiss: dismissSheet()
        default: print("Request not accepted on ParentView ")
        }
    }
    
    // MARK: - View Builders
    
    // Here we create on demand All Features.
    
    @ViewBuilder
    func build(feature: Feature) -> some View {
        switch feature {
        case .parent: ParentView(coordinator: self)
        case .firstChild: FirstChildView(coordinator: self)
        case .secondChild: SecondChildView(coordinator: self)
        case .creator: CreatorView(coordinator: self)
        }
    }
}
