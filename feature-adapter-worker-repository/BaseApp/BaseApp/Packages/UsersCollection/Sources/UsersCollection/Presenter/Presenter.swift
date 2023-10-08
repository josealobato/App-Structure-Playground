import UIKit

final class Presenter: ObservableObject, InteractorOutput {
    
    // MARK: - Input
    private let interactor: InteractorInput
    
    // MARK: - View Data
    @Published var viewModel: ViewModel
    @Published var isLoading = false  // TODO: to hide.
    
    init(interactor: InteractorInput) {
        
        self.interactor = interactor
        self.viewModel = .empty
    }
    
    // MARK: - InteractorOutput
    
    func dispatch(_ event: InteractorEvents.Output) {
        
        switch event {
            
        case .startLoading:
            isLoading = true
            
        case .noData:
            isLoading = false
            
        case .refresh(let users):
            isLoading = false
            viewModel = ViewModel.build(from: users)
        }
    }
}
