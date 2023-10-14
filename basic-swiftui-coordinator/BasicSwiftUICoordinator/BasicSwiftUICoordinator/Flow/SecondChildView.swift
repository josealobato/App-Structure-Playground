import SwiftUI

struct SecondChildView: View {
    
    // Problem 1: The fact that this view knows about the coordinator type
    // is an error. It means that this view can only be managed by this type
    // of flow.
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    
    var body: some View {
        Text("Second Child View")
        Button("Go to root") {
            coordinator.backToRoot()
        }
        .navigationTitle("Second Child")
    }
}

struct SecondChildView_Previews: PreviewProvider {
    static var previews: some View {
        SecondChildView()
    }
}
