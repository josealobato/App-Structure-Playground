import Foundation

// Access to the Automockable Interface.
import JToolKit

// Entitiies dependencies.
import struct Entities.Message

enum InteractorEvents {
    
    enum Input {
        
        case loadInitialData
    }
    
    enum Output: Equatable {
        
        case startLoading
        case noData
        case refresh([Message])
    }
}

protocol InteractorInput: AnyObject, AutoMockable {

    func request(_ event: InteractorEvents.Input) async
}

protocol InteractorOutput: AnyObject, AutoMockable {

    func dispatch(_ event: InteractorEvents.Output)
}

