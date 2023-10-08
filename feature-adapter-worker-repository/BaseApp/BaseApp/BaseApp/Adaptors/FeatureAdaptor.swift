
// Please Ignore this file since is not part of the exercice.
// It is just here as an extra example of the Coordinator.

import Foundation
import Feature
import struct Entities.Message
import protocol Repositories.MessageRepositoryProtocol
import struct Repositories.MessageRepositoryBuilder

/// Do the dependency inversion to adapt the Features interface to the Repository and/or Worker.
///
/// Also the Adaptor is at the application level so it is a good place to do a first Error management
/// by passing all errors by a Error builder and return a unique type of error with Application controlled
/// message.

final class FeatureAdaptor: FeatureServiceInterface {
    
    let messageRepository: MessageRepositoryProtocol = MessageRepositoryBuilder.build()
        
    func messages() async throws -> [Message] {
        
        let dataEntities = try await messageRepository.messages()
        let entities = dataEntities.map { Message.from(dataEntity: $0) }
        return entities
    }
}
