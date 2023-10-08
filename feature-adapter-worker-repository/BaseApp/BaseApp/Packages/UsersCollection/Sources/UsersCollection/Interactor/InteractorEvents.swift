import Foundation

// Access to the Automockable Interface.
import JToolKit

// Entitiies dependencies.
import struct Entities.User

enum InteractorEvents {
    
    enum Input {
        
        case loadInitialData
        case refresh
        case nextPage
    }
    
    enum Output: Equatable {
        
        case startLoading
        case noData
        case refresh([User])
    }
}

// MARK: - Interactor abstraction interfaces

/// These are the interfaces that abstracts the interactor from the input (View) and output (Presenter)

protocol InteractorInput: AnyObject, AutoMockable {

    func request(_ event: InteractorEvents.Input) async
}

protocol InteractorOutput: AnyObject, AutoMockable {

    func dispatch(_ event: InteractorEvents.Output)
}

