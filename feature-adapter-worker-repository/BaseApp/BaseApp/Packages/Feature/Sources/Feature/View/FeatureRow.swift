import SwiftUI

struct FeatureRow: View {
    
    var title: String
    var message: String

    var body: some View {
        HStack {
            // Hardcoded images. In reality it should come from the ViewModel.
            Image(systemName: "envelope")
                .scaledToFit()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                if !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .lineLimit(4)
                }
            }
        }
    }
}

struct FeatureRow_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let shortMessage = FeatureRow(title: "Short", message: "This is the text for a short message.")
        let longMessage = FeatureRow(title: "Long", message: "This is the text for a long message that will contain some more characters.")
        
        Group {
            List {
                shortMessage
                longMessage
            }
            .listStyle(.plain)
        }
    }
}
