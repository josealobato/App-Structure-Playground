import Foundation
import JToolKit

/// Public interface (together with a builder) of the Local Storage.

/// As you can see this protocol dependds on `UserDataEntity` so it wont be possible
/// to move it to an external package. To do so we will need to do dependency inversion
/// and offer our own type but that was overkilling for this demo project.

protocol UsersLocalStorageProtocol: AutoMockable {
    
    func persist(users: [UserDataEntity]) async
    
    func removeAllUsers() async
    
    func retriveUsers() async -> [UserDataEntity]
}
