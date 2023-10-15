import SwiftUI

@main
struct BasicSwiftUICoordinatorApp: App {
    var body: some Scene {
        WindowGroup {
            // We lauch the view of the Coordinator Flow.
            // The view and the coordinator work in pair to coordiante navigation and presentation.
            AppFlowView()
        }
    }
}
