import Foundation
import CoreData

/// This is how errors will be defined for the Local Storage.
/// But, but since the local storage is used as a simple cache, I won't
/// throw any error here.

enum LocalStorageError: Error {
    
    case internalError
}

/// Specific implementation of the `UsersLocalStorageProtocol`
final class UsersLocalStorage: UsersLocalStorageProtocol {
   
    let localStorage = LocalStorage()
    
    func persist(users: [UserDataEntity]) async {
        
        do {
            let context = localStorage.container.newBackgroundContext()
            
            _ = users.map { $0.mapPersistable(context: context) }
            
            try context.save()
        } catch {
            
            /// We should throw here but decided not to in this implementaion
            /// (see comment at the top of the file)
            print(" persist error \(error)")
        }
    }
    
    func removeAllUsers() async {
        
        do {
            let context = localStorage.container.newBackgroundContext()
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "UserMO")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try localStorage.container.persistentStoreCoordinator.execute(deleteRequest, with: context)
            
        } catch {
            
            print(" removeAllUsers error \(error)")
        }
    }
    
    func retriveUsers() async -> [UserDataEntity] {
        
        do {
            
            let moUsers: [UserMO] = try await localStorage.container.read()
            let users = moUsers.map { UserDataEntity.from(mo: $0) }
            
            return users
        } catch {
            
            /// We should throw here but decided not to in this implementaion
            /// (see comment at the top of the file)
            print(" retriveUsers error \(error)")
            return []
        }
    }
}
