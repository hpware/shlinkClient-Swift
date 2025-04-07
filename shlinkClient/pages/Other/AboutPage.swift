import SwiftUI

struct AboutPage: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Shlink Client")
                        .font(.title2)
                        .bold()
                    Text("A native iOS client for managing your Shlink URL shortener instances.")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Link("Shlink Documentation", destination: URL(string: "https://shlink.io/documentation/")!)
                Link("Report an Issue", destination: URL(string: "https://github.com/hpware/shlinkClient-swift/issues")!)
            }
        }
        .navigationTitle("About")
    }
}