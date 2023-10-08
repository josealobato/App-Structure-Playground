import Foundation

// The repository Protocols offers the `CRUD` like API to work with the different types
// of external data the the application needs.

public protocol UsersRepositoryProtocol {
   
    // Strategy 1: Arrays: remote and cache when not available.
    
    func usersFirstPage() async throws -> [UserDataEntity]
    func usersNextPage() async throws -> [UserDataEntity]
    
    // Strategy 2: Streams: local, the remote and update local with remote.
    
    func usersFirstPage() -> AsyncStream<[UserDataEntity]>
    func usersNextPage() -> AsyncStream<[UserDataEntity]>
}
