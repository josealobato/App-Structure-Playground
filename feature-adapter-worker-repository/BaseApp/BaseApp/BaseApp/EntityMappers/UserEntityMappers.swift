import Foundation

import struct Entities.User
import struct Repositories.UserDataEntity

extension User {
    
    static func from(dataEntity: UserDataEntity) -> User {
       
        Entities.User(id: dataEntity.id,
                      email: dataEntity.email,
                      name: User.NameParts(title: dataEntity.name.title,
                                           first: dataEntity.name.first,
                                           last: dataEntity.name.last)
        )
    }
}
