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
        FeatureListView(messages: presenter.viewModel.messages)
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
                
        @State private var viewModel =  ViewModel(messages: [
            ViewModel.MessageViewModel(id: "01", title: "One", message: "this is message One"),
            ViewModel.MessageViewModel(id: "02", title: "Two", message: "this is message Two"),
            ViewModel.MessageViewModel(id: "03", title: "Three", message: "this is message Three")
        ])
        
        var body: some View {
            FeatureListView(messages: viewModel.messages)
        }
    }
    
    static var previews: some View {
        NavigationView {
            TestContainer()
        }
        .previewDisplayName("Container View")
    }
}
