import Foundation

// Entitiies dependencies.
import struct Entities.Message

final class Interactor: InteractorInput {
    
    var output: InteractorOutput?
    var services: FeatureServiceInterface
    
    init(services: FeatureServiceInterface) {
        
        self.services = services
    }
    
    // MARK: - Intercator input

    func request(_ event: InteractorEvents.Input) async {

        switch event {

        case .loadInitialData: await onLoadInitialData()
        }
    }
    
    // MARK: - Error
    
    private func renderError(_ error: Error, retryAction: (() -> Void)? = nil) {
        // Work with coordinator to show the error (Snackbar, alert, etc.)
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
            
            let messages = try await services.messages()
            
            if messages.isEmpty {
                
                render(.noData)
            } else {
                
                render(.refresh(messages))
            }
            
        } catch {

            renderError(error)
        }
    }
}
