import Foundation
import Connectivity

enum RemoteStorageError: Error {
    
    case internalError
}

/// Specific implementation of the `UsersRemoteStorageProtocol`
final class UsersRemoteStorage: UsersRemoteStorageProtocol {
    
    /// Warning: not familiar with this framework. It is the first time I use it.
    let connectivity: Connectivity
    
    init() {
        
        connectivity = Connectivity()
        connectivity.framework = .network
    }
    
    func isAvailable() async -> Bool {
        
        await withCheckedContinuation { [connectivity] continuation in
            
            connectivity.checkConnectivity { connectivity in
                switch connectivity.status {
                case .connected:
                    continuation.resume(returning: true)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    func users(onPage: Int) async throws -> [UserDataEntity] {
        
        // I did notice that in order to get the rigth content on every page I needed to set different seed to every page.
        // So here I am setting a constant seed `qontoway` with a variable part that match the page.
        guard let url = URL(string: "https://randomuser.me/api/?page=\(onPage)&results=20&seed=qontoway\(onPage)") else {
            
            throw RemoteStorageError.internalError
        }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let usersResults = try JSONDecoder().decode(UsersResults.self, from: data)
            
            let users = usersResults.results.map { user in
                
                UserDataEntity(id: user.id.constructedID,
                               email: user.email,
                               name: UserDataEntity.NameParts(title: user.name.title,
                                                              first: user.name.first,
                                                              last: user.name.last))
            }
            
            return users
        } catch {
            
            throw RemoteStorageError.internalError
        }
    }
}
