import SwiftUI

// A dummy view to be used as sheet and Full Screen Cover.
struct CreatorView: View {
    
    var coordinator: CoordinatorRequestProtocol
    
    var body: some View {
        Text("Creator")
        Button("Dismiss") {
            coordinator.coordinate(from: CreatorView.self, request: .dismiss)
        }
    }
}

struct CreatorView_Previews: PreviewProvider {
    
    class MockCoordinator: CoordinatorRequestProtocol {
        func coordinate(from feature: any View.Type, request: CoordinatorRequest) { }
    }
    
    static var previews: some View {
        CreatorView(coordinator: MockCoordinator())
    }
}
