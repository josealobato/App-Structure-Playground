import Foundation
import CoreData

extension UserDataEntity {
    
    static func from(mo: UserMO) -> UserDataEntity {
        
        self.init(id: mo.id ?? "",
                  email: mo.email ?? "",
                  name: NameParts(title: mo.title ?? "",
                                  first: mo.first ?? "",
                                  last: mo.last ?? ""))
    }
}
