import SwiftUI

struct PrivacyPolicyPage: View {
    var body: some View {
        List {
            Section {
                Text("Your data is stored locally on your device. We do not collect any personal information. However, there will be a new feature that allows you to store your data to our cloud, this will be using a different Privacy policy.")
                    .padding(.vertical, 8)
            } header: {
                Text("Privacy Policy")
            }
        }
        .navigationTitle("Privacy")
    }
}
