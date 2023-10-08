import Foundation

// The repository Protocols offers the `CRUD` like API to work with the different types
// of external data the the application needs.

public protocol UsersRepositoryProtocol {
   
    // Strategy 1: Arrays: Returns the remote data and local data only when remote is not available.
    
    func usersFirstPage() async throws -> [UserDataEntity]
    func usersNextPage() async throws -> [UserDataEntity]
    
    // Strategy 2: Streams: returns local, then the remote and finally update local with
    // the new remote data.
    // This strategy is not currently used in the application since it is under development.
    // But, it is implemented and you can see all happy path unit test in files
    // `UserRepositoryStreamStrategyFirstPageTests` and
    // `UserRepositoryStreamStrategyNextPageTests`
    
    func usersFirstPage() -> AsyncStream<[UserDataEntity]>
    func usersNextPage() -> AsyncStream<[UserDataEntity]>
}
