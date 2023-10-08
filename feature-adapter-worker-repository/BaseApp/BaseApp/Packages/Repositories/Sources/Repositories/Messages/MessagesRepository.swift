import Foundation

/// The internal repositories implements the public repositories protocol.
///
/// It is also the place to have a smart implementation and decide if the data comes
/// from internal on device cache or from the remote services. That way it abstracts
/// the handling of data from the rest of the application.
///

final class MessageRepository: MessageRepositoryProtocol {
    
    func messages() async throws -> [MessageDataEntity] {
        
//        [
//            MessageDataEntity(id: "1", title: "First Message", message: "What are you doing right now?"),
//            MessageDataEntity(id: "2", title: "Second Message", message: "What are you doing right now?"),
//            MessageDataEntity(id: "3", title: "Third Message", message: "What are you doing right now?"),
//            MessageDataEntity(id: "4", title: "Forth Message", message: "What are you doing right now?")
//        ]
        
        guard let url = URL(string: "https://api.quotable.io/quotes") else {
            return []
            //throw FetcherError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let quotes = try JSONDecoder().decode(QuotesResults.self, from: data)
        
        let messages = quotes.results.map { quote in
            MessageDataEntity(id: quote._id, title: quote.author, message: quote.content)
        }
        
        return messages
    }
}

struct QuotesResults: Codable {
    
    struct Quote: Codable {
        let _id: String
        let author: String
        let content: String
    }
    
    let results: [Quote]
}
