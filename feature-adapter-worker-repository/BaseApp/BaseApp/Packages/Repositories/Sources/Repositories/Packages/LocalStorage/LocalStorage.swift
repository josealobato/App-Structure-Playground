import Foundation
import CoreDataStack

public enum BundleReference {
    public static let bundle = Bundle.module
}

final class LocalStorage {
    
    let container = PersistentContainer(name: "LocalStorage",
                                        inMemory: false,
                                        bundle: BundleReference.bundle)
    
    init() {
        
        container.loadPersistentStores { desc, error in

            print(" container error \(error.debugDescription)")
        }
    }
}
