import SwiftUI

// A dummy view to be used on the navigation.
struct FirstChildView: View {
    
    var coordinator: CoordinatorRequestProtocol
    
    var body: some View {

        VStack {
            Text("First Child View")
            Button("Go to child") {
                coordinator.coordinate(from: FirstChildView.self, request: .secondChild)
            }
            Divider()
            Button("Show Creator") {
                coordinator.coordinate(from: FirstChildView.self, request: .creator)
            }
        }
        .navigationTitle("First Child")
    }
}

struct FirstChildView_Previews: PreviewProvider {
    
    class MockCoordinator: CoordinatorRequestProtocol {
        func coordinate(from feature: any View.Type, request: CoordinatorRequest) { }
    }
    
    static var previews: some View {
        FirstChildView(coordinator: MockCoordinator())
    }
}
