import SwiftUI

struct FeatureListView: View {
    
    var users: [ViewModel.UserViewModel]
    var isComplete = false
    var onRefresh: (() -> Void)
    var onNext: (() -> Void)
    
    var body: some View {
        List {
            
            ForEach(users) { user in
                
                FeatureRow(title: user.name,
                           subtitle: user.email)
            }
            
            if isComplete == false && !users.isEmpty {
                
                HStack {
                    
                    Spacer()
                    ProgressView()
                        .onAppear {
                            
                            onNext()
                        }
                    Spacer()
                }
            }
            
        }
        .listStyle(.plain)
        /// This localization is hardcoded, it should be `LocalizationKey.lectures.localize()`
        .navigationTitle("Users")
        .refreshable { onRefresh() }
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    
    @State static var models = [
        ViewModel.UserViewModel(id: "01", name: "Mr Johnson", email: "jack.johnson@papel.com"),
        ViewModel.UserViewModel(id: "02", name: "Ms Jane", email: "jannise.jane@papel.com"),
        ViewModel.UserViewModel(id: "03", name: "Mrs Elikson", email: "elena.elikson@pape.com")
    ]
    
    static var previews: some View {
        
        NavigationView {
            
            FeatureListView(users: models, onRefresh: { }, onNext: { })
        }
    }
}
