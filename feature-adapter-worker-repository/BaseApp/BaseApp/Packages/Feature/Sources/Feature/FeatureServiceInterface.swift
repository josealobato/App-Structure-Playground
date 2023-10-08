import Foundation

// Required for the AutoMockable
import JToolKit

// Entities dependencies.
import struct Entities.Message

/// The `FeatureServiceInterface` represents the services required by the Feature.
public protocol FeatureServiceInterface: AutoMockable {
    
    /// Get the list of messages.
    /// - Throws: Error occur on getting the message list.
    /// - Returns: The most up to date messages list.
    func messages() async throws -> [Message]
}
