import SwiftUI

// A dummy view to be used on the navigation.
struct SecondChildView: View {
    
    var coordinator: CoordinatorRequestProtocol
    
    var body: some View {
        Text("Second Child View")
        Button("Go to root") {
            coordinator.coordinate(from: SecondChildView.self, request: .backToRoot)
        }
        Divider()
        Button("Show Creator (full Cover)") {
            coordinator.coordinate(from: SecondChildView.self, request: .creator)
        }
        .navigationTitle("Second Child")
    }
}

struct SecondChildView_Previews: PreviewProvider {
    
    class MockCoordinator: CoordinatorRequestProtocol {
        func coordinate(from feature: any View.Type, request: CoordinatorRequest) { }
    }
    
    static var previews: some View {
        SecondChildView(coordinator: MockCoordinator())
    }
}
