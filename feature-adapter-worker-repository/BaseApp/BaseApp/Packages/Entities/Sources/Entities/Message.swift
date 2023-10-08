import Foundation

public struct Message: Identifiable, Equatable {
    
    public let id: String
    public let title: String
    public let message: String
    
    public init(id: String,
                title: String,
                message: String) {
        self.id = id
        self.title = title
        self.message = message
    }
}
