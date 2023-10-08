import Foundation

// The repository Protocols offers the `CRUD` like API to work with the different types
// of external data the the application needs.

public protocol MessageRepositoryProtocol {
   
    func messages() async throws -> [MessageDataEntity]
}
