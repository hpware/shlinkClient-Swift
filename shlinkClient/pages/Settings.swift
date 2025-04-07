import SwiftUI
import SwiftData

struct SettingsPage: View {
    enum Field: Hashable {
        case url
        case token
    }
    @Environment(\.modelContext) private var modelContext
    @Query private var servers: [Server]
    @State private var newURL = ""
    // Import from needed plugins from the rest folding the staring should only be rest_{theapi}
    @StateObject private var rest_Health = HealthRest()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Add a new Shlink instance")) {
                    VStack {
                        TextField(
                            "Enter your Server URL",
                            text: $newURL
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .url)
                        .submitLabel(.next)
                        .onSubmit{
                            focusedField = .token
                        }
                        Spacer()
                        HStack {
                            TextField(
                            "Enter your private token.",
                            text: $newURL
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .token)
                        .onSubmit(createNewServer)
                        Button(action: createNewServer) {
                            Image(systemName: "plus")
                        }.disabled(newURL.isEmpty)
                        }
                    }
                    .padding(.vertical, 8)
                }
                Section(header: Text("Your Shlink Instances")) {
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
                Section(
                    header: Text("Other"),
                    footer: Text("Shlink iOS Manager v0.1.0").font(.footnote).foregroundStyle(.secondary)
                ) {
                    NavigationLink(destination: PrivacyPolicyPage()) {
                        Label("How we use your data", systemImage: "lock.shield")
                    }
                    NavigationLink(destination: AboutPage()) {
                        Label("About this app", systemImage: "info.circle")
                    }
                    // WHY DOES IT NEED A ! IN THE END?? WHAT THE FUCK IS WRONG
                    Link(destination: URL(string: "https://github.com/hpware/shlinkclient-Swift")!) {
                        HStack {
                            Label("Source code", systemImage: "chevron.left.forwardslash.chevron.right")
                            Image(systemName: "link")
                        }
                    }
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
