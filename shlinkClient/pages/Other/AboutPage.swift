import StoreKit
import SwiftUI

struct AboutPage: View {
    @Environment(\.requestReview) var requestReview
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Shlink Client")
                        .font(.title2)
                        .bold()
                    Text("A native iOS client using SwiftLang for managing your Shlink URL shortener instances. No finiky webUIs and Shortcuts.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section {
                Button("Leave a review") {
                    requestReview()
                }
                // WHY DOES IT NEED A ! IN THE END??
                Link(destination: URL(string: "https://github.com/hpware/shlinkclient-Swift")!) {
                    Text("Source code")
                }
                Link("Shlink Documentation", destination: URL(string: "https://shlink.io/documentation/")!)
                Link("Report an Issue", destination: URL(string: "https://github.com/hpware/shlinkClient-swift/issues")!)
            }
            .foregroundColor(.white)
            .tint(.white)
        }
        .navigationTitle("About")
    }
}
