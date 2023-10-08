import Foundation
// Feature
import struct UsersCollection.UsersCollectionBuilder
import protocol UsersCollection.UsersCollectionServiceInterface
// Entities
import struct Entities.User
// Repositories
import protocol Repositories.UsersRepositoryProtocol
import struct Repositories.UsersRepositoryBuilder

/// Do the dependency inversion to adapt the Features interface to the Repository and/or Worker.
///
/// Also the Adaptor is at the application level so it is a good place to do a first Error management
/// by passing all errors by a Error builder and return a unique type of error with Application controlled
/// message.

final class UsersCollectionAdaptor: UsersCollectionServiceInterface {
    
    func usersFirstPage() async throws -> [Entities.User] {
        
        let dataEntities = try await usersRepository.usersFirstPage()
        let entities = dataEntities.map { User.from(dataEntity: $0) }
        return entities
    }
    
    func usersNextPage() async throws -> [Entities.User] {
        
        let dataEntities = try await usersRepository.usersNextPage()
        let entities = dataEntities.map { User.from(dataEntity: $0) }
        return entities
    }
    
    let usersRepository: UsersRepositoryProtocol = UsersRepositoryBuilder.build()
}
