import SwiftUI

struct ParentView: View {
    
    // Problem 1: The fact that this view knows about the coordinator type
    // is an error. It means that this view can only be managed by this type
    // of flow.
    @EnvironmentObject private var coordinator: AppFlowCoordinator
    
    var body: some View {
        VStack {
            Text("Parent View")
            Button("Go to child") {
                coordinator.push(.firstChild)
            }
        }
        .navigationTitle("Parent")
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}
