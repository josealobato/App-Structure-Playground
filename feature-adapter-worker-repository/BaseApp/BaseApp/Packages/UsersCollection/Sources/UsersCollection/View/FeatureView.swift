import SwiftUI

struct FeatureView: View {
    
    enum ViewState {
        
        case loading
    }
    
    @StateObject private var presenter: Presenter
    let interactor: InteractorInput
    
    init(presenter: Presenter, interactor: InteractorInput) {
        
        self._presenter = StateObject(wrappedValue: presenter)
        self.interactor = interactor
    }
    
    var body: some View {
        FeatureListView(users: presenter.viewModel.users,
                        onRefresh: { request(.refresh) },
                        onNext: { request(.nextPage) })
            /// This localization is hardcoded, it should be `LocalizationKey.lectures.localize()`
            .navigationTitle("Lecture List")
            .onAppear { request(.loadInitialData) }
            .refreshable { request(.loadInitialData) }
    }
    
    func request(_ event: InteractorEvents.Input) {

        Task {

            await interactor.request(event)
        }
    }
}

struct FeatureView_Previews: PreviewProvider {
    
    struct TestContainer: View {
                
        @State private var viewModel =  ViewModel(users: [
            ViewModel.UserViewModel(id: "01", name: "Mr Johnson", email: "jack.johnson@papel.com"),
            ViewModel.UserViewModel(id: "02", name: "Ms Jane", email: "jannise.jane@papel.com"),
            ViewModel.UserViewModel(id: "03", name: "Mrs Elikson", email: "elena.elikson@pape.com")
        ])
        
        var body: some View {
            
            FeatureListView(users: viewModel.users,
                            onRefresh: { },
                            onNext: { })
        }
    }
    
    static var previews: some View {
        NavigationView {
            
            TestContainer()
        }
        .previewDisplayName("Container View")
    }
}
