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
                Section(header: Text("Your Shlink Instances")) {
                    HStack {
                        TextField(
                            "Add a new Shlink instance",
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
                            if rest_Health.loadingURLs.contains(i.url)  {
                                ProgressView()
                            // this is just to point a temp value for the if values to do stuff with. Awesome, no global vars are needed.
                            } else if let status = rest_Health.healthStatuses[i.url] {
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
                    }.onDelete(perform: deleteServers)
                } 
            }.navigationTitle("Settings")
        }
    }

    private func createNewServer() {
        withAnimation {
            guard !newURL.isEmpty else {
               return
            }
            var urlString = newURL.trimmingCharacters(in: .whitespacesAndNewlines)
            guard urlString.contains(".") else {
                return
            }
            if !urlString.contains("://") {
                urlString = "https://" + urlString
            }
            guard let url = URL(string: urlString),
                url.scheme != nil,
                url.host != nil else {
                    return
                }
            
            let server = Server(url: urlString)
            modelContext.insert(server)
            do {
                try modelContext.save()
                newURL = ""
                Task {
                    await rest_Health.fetchHealthData(url: server.url)
                }
            } catch {
            }
        }
    }
    private func deleteServers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(servers[index])
            }
        }
    }
}
