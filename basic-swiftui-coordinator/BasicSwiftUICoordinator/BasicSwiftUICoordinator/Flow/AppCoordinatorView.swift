import SwiftUI

struct AppFlowView: View {
    
    @StateObject private var coordinator = AppFlowCoordinator()
    
    var body: some View {
        // the AppFlowView Controls a navigation flow in this case.
        NavigationStack(path: $coordinator.path) {
            // Request the coordinato creating the first view and use it as root view of the
            // navigation.
            coordinator.build(page: .parent)
                // Note that the navigation destination should be somewhere inside the Navigation.
                .navigationDestination(for: Page.self, destination: { page in
                    coordinator.build(page: page)
                })
        }
        // injectiing the coordinator to the environment allowing the rest
        // of the views to have access to this coordinator.
        .environmentObject(coordinator)
    }
}

struct AppFlowView_Preview: PreviewProvider {
    static var previews: some View {
        AppFlowView()
    }
}
