import Foundation

public struct User: Identifiable, Equatable {
    
    public struct NameParts: Equatable {
        
        public let title: String
        public let first: String
        public let last: String
        
        public init(title: String, first: String, last: String) {
            self.title = title
            self.first = first
            self.last = last
        }
    }
    
    public let id: String
    public let email: String
    public let name: NameParts
    
    public init(id: String, email: String, name: NameParts) {
        
        self.id = id
        self.email = email
        self.name = name
    }
}

public extension User {
    
    // This is an very basic example of Business Logic. Depending on the settings that the user might have on the
    // serverside (Business) we will build the structure of the name accordingly.
    var fullName: String {
        
        "\(name.title) \(name.first) \(name.last)"
    }
}
