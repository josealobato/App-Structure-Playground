import Foundation

/// Building a repository will involves different other internal objects or dependencies like
/// on device caches (localStorage) and/or remote controllers to connect to external servers (remoteStorage).
/// All this internal building details are abstracted to user with the repository builders.
///
/// These builder, together with the data entities, are the ONLY public face of the repositories package,
/// and they offer only what the external user needs: an object that conforms to the repository protocol.

public struct UsersRepositoryBuilder {
    
    public static func build() -> UsersRepositoryProtocol {
        
        UsersRepository(remoteStorage: UsersRemoteStorage(),
                        localStorage: UsersLocalStorage())
    }
}
