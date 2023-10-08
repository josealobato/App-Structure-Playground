import Foundation
import CoreData

extension  UserMO {
    
    convenience init(model: UserDataEntity, context: NSManagedObjectContext) {
        
        self.init(using: context)
        id = model.id
        email = model.email
        title = model.name.title
        first = model.name.first
        last = model.name.last
    }
}

extension UserDataEntity {
    
    public func mapPersistable(context: NSManagedObjectContext) -> UserMO {
        
        UserMO(model: self, context: context)
    }
}
