import SwiftUI

struct PrivacyPolicyPage: View {
    var body: some View {
        List {
            Section {
                Text("Your data is stored locally on your device. We do not collect any personal information.")
                    .padding(.vertical, 8)
            } header: {
                Text("Privacy Policy")
            }
            // Maybe this will never ship to the public. This feels not that great, maybe just export as a zip file?
            /** Section {
                 Text("This feature is currently not available. view")
                 Link(destination: URL(string: "https://yuanhau.com/pages/shlinkClient_Cloud")!) {
                 Text("this")
                 }
             } header: {
                 Text("Your data on the cloud")
             } */
        }
        .navigationTitle("Privacy")
    }
}
