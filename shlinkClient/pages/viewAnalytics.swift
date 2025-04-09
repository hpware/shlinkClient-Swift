import SwiftUI

struct ViewAnalytics: View {
    var body: some View {
        Section {
            HStack {
                // Visits
                VStack {
                    Text("Visits")
                    Text("3333")
                }
                // Orphan Visits
                VStack {
                    Text("Orphan Visits")
                    Text("3933")
                }
                // Short URLs
                VStack {
                    Text("Short URLs")
                    Text("3")
                }
                // Tags
                VStack {
                    Text("Tags")
                    Text("0")
                }
            }
        }
    }
}
