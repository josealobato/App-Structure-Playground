import Foundation

struct UsersResults: Codable {
    struct Users: Codable {
        
        struct NameParts: Codable {
            
            let title: String
            let first: String
            let last: String
        }
        
        struct Identifier: Codable {
            let name: String?
            let value: String?
            
            var constructedID: String {
                // WARNING: Bad way to construct an "unique" id.
                // We should also discard elements with the same or null ID.
                let cname = (name ?? "") + (value ?? "")
                if cname.isEmpty { return UUID().uuidString }
                else { return cname }
            }
        }
        
        public let id: Identifier
        public let email: String
        public let name: NameParts
    }
    
    let results: [Users]
    
    struct MetaInformation: Codable {
        
        let page: Int
    }
    
    let info: MetaInformation
}

