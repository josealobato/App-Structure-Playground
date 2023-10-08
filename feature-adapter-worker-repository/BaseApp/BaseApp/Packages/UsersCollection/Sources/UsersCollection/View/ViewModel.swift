import Foundation
import struct Entities.User

struct ViewModel {
    
    struct UserViewModel: Identifiable, Equatable {
        
        let id: String
        let name: String
        let email: String
    }
    
    let users: [UserViewModel]
    let isComplete = false
    
    // MARK: - Default Values
    
    static var empty: ViewModel {
        
        ViewModel(users: [])
    }
}

extension ViewModel {
    
    static func build(from users: [User]) -> ViewModel {
        
        let usersViewModels = users.map { user in
            ViewModel.UserViewModel(id: user.id,
                                    name: user.fullName,
                                    email: user.email)
        }
        
        return ViewModel(users: usersViewModels)
    }
}
