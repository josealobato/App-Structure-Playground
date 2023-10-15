import SwiftUI

// This is the partner of the `AppFlowCoordinator` Coordination.
// This view catches the navigation/presentation events and forward them to the
// Coordinator that handled and do the navigation/presentation actions accordingly.
struct AppFlowView: View {
    
    @StateObject private var coordinator = AppFlowCoordinator()
    @StateObject private var flowOneCoordinator = FlowOneCoordinator()
    @StateObject private var flowTwoCoordinator = FlowTwoCoordinator()
    
    var body: some View {
        TabView {
            
            NavigationStack(path: $flowOneCoordinator.path) {
                ParentView(coordinator: flowOneCoordinator)
                    .navigationDestination(for: Feature.self) { page in
                        flowOneCoordinator.build(feature: page)
                    }
                    .sheet(item: $flowOneCoordinator.sheet) { sheet in
                        flowOneCoordinator.build(feature: sheet)
                    }
                    .fullScreenCover(item: $flowOneCoordinator.screenCover) { screenCover in
                        flowOneCoordinator.build(feature: screenCover)
                    }
            }
            .tabItem {
                Label("First", systemImage: "1.circle")
            }
            
            NavigationStack(path: $flowTwoCoordinator.path) {
                ParentView(coordinator: flowTwoCoordinator)
                    .navigationDestination(for: Feature.self) {page in
                        flowTwoCoordinator.build(feature: page)
                    }
                    .sheet(item: $flowTwoCoordinator.sheet) { sheet in
                        flowTwoCoordinator.build(feature: sheet)
                    }
                    .fullScreenCover(item: $flowTwoCoordinator.screenCover) {  screenCover in
                        flowTwoCoordinator.build(feature: screenCover)
                    }
            }
            .tabItem {
                Label("Second", systemImage: "2.circle")
            }
            
            //        NavigationStack(path: $coordinator.path) {
            //            coordinator.build(feature: .parent)
            //                .navigationDestination(for: Feature.self) { page in
            //                    coordinator.build(feature: page)
            //                }
            //                .sheet(item: $coordinator.sheet) { sheet in
            //                    coordinator.build(feature: sheet)
            //                }
            //                .fullScreenCover(item: $coordinator.screenCover) { screenCover in
            //                    coordinator.build(feature: screenCover)
            //                }
            
        }
    }
}

struct AppFlowView_Preview: PreviewProvider {
    static var previews: some View {
        AppFlowView()
    }
}
