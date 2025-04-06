import SwiftUI
import SwiftData

struct SettingsPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var servers: [Server]
    @State private var newURL = ""
    // Import from needed plugins from the rest folding the staring should only be rest_{theapi}
    @StateObject private var rest_Health = HealthRest()

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Your Servers")) {
                    VStack {
                        TextField(
                            "Your Shlink Instance",
                            text: $newURL
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit(createNewServer)
                        Button(action: createNewServer) {
                            Image(systemName: "plus")
                        }.disabled(newURL.isEmpty)
                    }
                    ForEach(servers) {
                        i in 
                        HStack() {
                            Text(i.url).font(.headline)
                            Spacer()
                            if rest_Health.isLoading {
                                ProgressView()
                            // this is just to point a temp value for the if values to do stuff with. Awesome, no global vars are needed.
                            } else if let status = rest_Health.healthStatus {
                                if status.status == "pass" {
                                    Image(systemName: "checkmark.seal.fill")
                                } else {
                                    Image(systemName: "xmark.seal.fill")
                                }
                                if let vis = status.version {
                                    Text("Version: \(vis)")
                                }
                            }
                        }
                    }
                } 
            }
        }.navigationTitle("Settings")
    }

    private func createNewServer() {
        withAnimation {
            guard !newURL.isEmpty else {
               return
            }
            var urlString = newURL.trimmingCharacters
        }
    }
}
