import Foundation

import struct Entities.Message
import struct Repositories.MessageDataEntity

extension Message {
    
    static func from(dataEntity: MessageDataEntity) -> Message {
        
        Message(id: dataEntity.id,
                title: dataEntity.title,
                message: dataEntity.message)
    }
}

