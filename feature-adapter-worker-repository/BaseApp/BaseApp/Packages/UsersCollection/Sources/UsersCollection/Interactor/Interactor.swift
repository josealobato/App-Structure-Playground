import Foundation

// Entities dependencies.
import struct Entities.User

final class Interactor: InteractorInput {
    
    var output: InteractorOutput?
    var services: UsersCollectionServiceInterface
    
    init(services: UsersCollectionServiceInterface) {
        
        self.services = services
    }
    
    // MARK: - Intercator input

    func request(_ event: InteractorEvents.Input) async {

        switch event {

        case .loadInitialData: await onLoadInitialData()
        case .refresh: await onRefresh()
        case .nextPage: await onNext()
        }
    }
    
    // MARK: - Error
    
    private func renderError(_ error: Error, retryAction: (() -> Void)? = nil) {
        // Work with coordinator to show the error (Snackbar, alert, etc.)
        print("Interactor Error: \(error)")
    }

    // MARK: - Intercator output

    private func render(_ event: InteractorEvents.Output) {

        DispatchQueue.main.async {

            self.output?.dispatch(event)
        }
    }
    
    // MARK: - Interaction management
    
    private func onLoadInitialData() async {

        render(.startLoading)
    
        do {
            
            let Users = try await services.usersFirstPage()
            
            if Users.isEmpty {
                
                render(.noData)
            } else {
                
                render(.refresh(Users))
            }
            
        } catch {

            renderError(error)
        }
    }
    
    private func onRefresh() async {
        
        await onLoadInitialData()
    }
    
    private func onNext() async {

        do {
            
            let Users = try await services.usersNextPage()
            
            if Users.isEmpty {
                
                render(.noData)
            } else {
                
                render(.refresh(Users))
            }
            
        } catch {

            renderError(error)
        }
    }
}
