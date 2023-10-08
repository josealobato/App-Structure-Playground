import Foundation
import struct Entities.Message

struct ViewModel {
    
    struct MessageViewModel: Identifiable, Equatable {
        
        let id: String
        let title: String
        let message: String
    }
    
    let messages: [MessageViewModel]
    
    // MARK: - Default Values
    
    static var empty: ViewModel {
        
        ViewModel(messages: [])
    }
}

extension ViewModel {
    
    static func build(from messages: [Message]) -> ViewModel {
        
        let messagesViewModels = messages.map { message in
            ViewModel.MessageViewModel(id: message.id,
                                       title: message.title,
                                       message: message.message)
        }
        
        return ViewModel(messages: messagesViewModels)
    }
}
