import Foundation

/// Building a repository will involves different other internal objects or dependencies like
/// on device caches and/or remote controllers to connect to external servers.
/// All this internal building details are abstracted to user with the repository builders.
///
/// These builder, together with the data entities, are the public face of the repositories package,
/// and offer only what the external user needs: an object that conforms to the repository protocol.

public struct MessageRepositoryBuilder {
    
    public static func build() -> MessageRepositoryProtocol {
        
        MessageRepository()
    }
}
