import SwiftUI

// This is the partner of the `AppFlowCoordinator` Coordination.
// This view catches the navigation/presentation events and forward them to the
// Coordinator that handled and do the navigation/presentation actions accordingly.
struct AppFlowView: View {
    
    @StateObject private var coordinator = AppFlowCoordinator()
    
    var body: some View {
        // The AppFlowView Controls a navigation flow in this case.
        NavigationStack(path: $coordinator.path) {
            // Request the coordinato creating the first view and use it as root view of the
            // navigation.
            coordinator.build(feature: .parent)
                // Note that the navigation destination should be somewhere inside the Navigation.
                .navigationDestination(for: Feature.self) { page in
                    coordinator.build(feature: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(feature: sheet)
                }
                .fullScreenCover(item: $coordinator.screenCover) { screenCover in
                    coordinator.build(feature: screenCover)
                }
            
        }
        // Injecting the coordinator to the environment allowing the rest
        // of the views to have access to this coordinator.
        //.environmentObject(coordinator)
        // this is not necessary since we are manually injecting the protocol on all Features
    }
}

struct AppFlowView_Preview: PreviewProvider {
    static var previews: some View {
        AppFlowView()
    }
}
