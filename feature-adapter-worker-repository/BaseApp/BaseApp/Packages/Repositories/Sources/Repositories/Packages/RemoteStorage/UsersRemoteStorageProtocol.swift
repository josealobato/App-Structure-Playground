import Foundation
import JToolKit

/// Public interface (together with a builder) of the Remote Storage.

/// As you can see this protocol dependds on `UserDataEntity` so it wont be possible
/// to move it to an external package. To do so we will need to do dependency inversion
/// and offer our onw type but that was overkilling for this demo project.

protocol UsersRemoteStorageProtocol: AutoMockable {
   
    func isAvailable() async -> Bool
    
    func users(onPage: Int) async throws -> [UserDataEntity]
}
