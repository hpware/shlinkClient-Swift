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
        }
        .navigationTitle("Privacy")
    }
}