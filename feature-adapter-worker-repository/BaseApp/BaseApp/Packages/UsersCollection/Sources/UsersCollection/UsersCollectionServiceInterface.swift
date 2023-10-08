import Foundation

// Required for the AutoMockable
import JToolKit

// Entities dependencies.
import struct Entities.User

/// The `UsersCollectionServiceInterface` represents the services required by the Feature.
public protocol UsersCollectionServiceInterface: AutoMockable {
        
    /// Get the initial set of data.
    /// - Returns: The initial Collection of Users
    func usersFirstPage() async throws -> [User]
    
    /// Get the current data plus new data if any.
    /// - Returns: The last data requested plus any new data available.
    func usersNextPage() async throws -> [User]
}
