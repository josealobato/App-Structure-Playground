import Foundation

public struct UserDataEntity: Equatable {
    
    public struct NameParts: Equatable {
        
        public let title: String
        public let first: String
        public let last: String
    }
    
    public let id: String
    public let email: String
    public let name: NameParts
}


