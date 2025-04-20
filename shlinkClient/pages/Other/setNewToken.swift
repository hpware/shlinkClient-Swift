import SwiftData
import SwiftUI

struct setNewToken: View {
    @State private var showReallySure = false
    @State private var newToken = ""
    @State private var oldVisible = false
    // Global Store (token)
    @StateObject private var globalStore = GlobalStore.shared
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This is where you can reset & update your token, if you have no idea how to do so, please advise the Shlink docs or an AI. (Just connect to your docker container and type in this command: \n shlink api-key:generate --name=ios_app )")
                        .padding(.vertical, 8)
                }
                HStack {
                    Text("Your old Token: ")
                    if oldVisible {
                        SecureField("\(globalStore.token)", text: $globalStore.token)
                            .disabled(true)
                    } else {
                        Text("\(globalStore.token)")
                    }
                    Spacer()
                    Button(
                        action: {
                            oldVisible = !oldVisible
                        }
                    ) {
                        if oldVisible {
                            Image(systemName: "eye")
                        } else {
                            Image(systemName: "eye.slash")
                        }
                    }
                }
                SecureField(
                    "Your new Token here",
                    text: $newToken
                )
                .submitLabel(.send)
                .onSubmit {
                    showReallySure = true
                }
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
            ) /** .dismissKeyboardTap() */
        /* .alert(
             "Are you really want to "
         ) */
    }
}
