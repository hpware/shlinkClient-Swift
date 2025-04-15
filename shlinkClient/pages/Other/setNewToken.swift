import SwiftData
import SwiftUI

struct setNewToken: View {
    @State private var showReallySure = false
    @State private var newToken = ""
    // Global Store (token)
    @StateObject private var globalStore = GlobalStore.shared
    var body: some View {
        NavigationStack {
            List {
                // DEBUGGING ONLY (IN PROD IT MUST BE ONLY DISPLAYING THE FIRST FEW DIGITS.
                Text(globalStore.token)
                SecureField(
                    "Your new Token here",
                    text: $newToken
                )
                .submitLabel(.send)
                .onSubmit {
                    showReallySure = true
                }
                Spacer()
                Button("Submit") {
                    showReallySure = true
                }
                .disabled(newToken.isEmpty)
            }
        }.navigationTitle("Change Your Token")
            .alert(
                "Are you really sure?",
                isPresented: $showReallySure,
                actions: {
                    Button("Sure", role: .destructive) {
                        globalStore.token = newToken
                        newToken = ""
                    }
                    Button("Cancel", role: .cancel) {
                        showReallySure = false
                    }

                },
                message: {
                    Text("Make sure the corrent token is entered, if the token is wrong, you can't do any actions other than checking it's status.")
                }
            )/**.dismissKeyboardTap()*/
    }
}
