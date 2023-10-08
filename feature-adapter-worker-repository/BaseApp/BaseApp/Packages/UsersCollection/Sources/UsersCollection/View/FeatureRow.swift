import SwiftUI

struct FeatureRow: View {
    
    var title: String
    var subtitle: String

    var body: some View {
        HStack {
            // Hardcoded images. In reality it should come from the ViewModel.
            Image(systemName: "person")
                .scaledToFit()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                if !subtitle.isEmpty {
                    Text(subtitle)
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
        
        let shortUser = FeatureRow(title: "Mr. Johnson", subtitle: "mike.johnson@papel.com")
        let longUser = FeatureRow(title: "Ms. Jane", subtitle: "alice.jane@papel.com")
        
        Group {
            List {
                shortUser
                longUser
            }
            .listStyle(.plain)
        }
    }
}
