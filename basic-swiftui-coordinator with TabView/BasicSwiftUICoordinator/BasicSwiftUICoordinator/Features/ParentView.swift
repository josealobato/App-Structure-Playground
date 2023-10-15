import SwiftUI

// A dummy view to be used on the navigation.
struct ParentView: View {
    
    var coordinator: CoordinatorRequestProtocol
    
    var body: some View {
        VStack {
            Text("Parent View")
            Button("Go to child") {
                coordinator.coordinate(from: ParentView.self, request: .firstChild)
            }
        }
        .navigationTitle("Parent")
    }
}

struct ParentView_Previews: PreviewProvider {
    
    class MockCoordinator: CoordinatorRequestProtocol {
        func coordinate(from feature: any View.Type, request: CoordinatorRequest) { }
    }
    
    static var previews: some View {
        ParentView(coordinator: MockCoordinator())
    }
}
