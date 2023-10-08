import SwiftUI

struct FeatureListView: View {
    
    var messages: [ViewModel.MessageViewModel]
    
    var body: some View {
        List {
            ForEach(messages) { message in
                FeatureRow(title: message.title,
                           message: message.message)
            }
        }
        .listStyle(.plain)
        /// This localization is hardcoded, it should be `LocalizationKey.lectures.localize()`
        .navigationTitle("Messages")
        
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    
    @State static var models = [
        ViewModel.MessageViewModel(id: "01", title: "One", message: "this is message One"),
        ViewModel.MessageViewModel(id: "02", title: "Two", message: "this is message Two"),
        ViewModel.MessageViewModel(id: "03", title: "Three", message: "this is message Three")
    ]
    
    static var previews: some View {
        NavigationView {
            FeatureListView(messages: models)
        }
    }
}
