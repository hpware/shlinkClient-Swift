import SwiftData
import SwiftUI

struct SettingsPage: View {
    enum Field: Hashable {
        case url
        case token
    }

    // ENVS
    @Environment(\.modelContext) private var modelContext
    // FETCH SERVERS
    @Query private var servers: [Server]
    // @StateObject the main globalStore first then @Query the GlobalStore.shared, yes that makes sense.
    @StateObject private var globalStore = GlobalStore.shared
    // TextField
    @State private var newURL = ""
    @State private var newToken = ""
    @State private var newDomain = ""
    // Import from needed plugins from the rest folding the staring should only be rest_{theapi}
    @StateObject private var rest_Health = HealthRest()
    @FocusState private var focusedField: Field?
    // Select Servers
    @State private var selectedServers = Set<String>()
    @State private var showResetAlert = false
    @State private var showUpdateShlinkToken = false

    //
    var token: String {
        globalStore.token
    }

    var body: some View {
        NavigationStack {
            List {
                /* Section(header: Text("Add a new Shlink instance")) {
                     VStack {
                         TextField(
                             "Enter your Server URL",
                             text: $newURL
                         )
                         .textInputAutocapitalization(.never)
                         .disableAutocorrection(true)
                         .focused($focusedField, equals: .url)
                         .submitLabel(.next)
                         .onSubmit {
                             focusedField = .token
                         }
                         Spacer()
                         HStack {
                             SecureField(
                                 "Enter your token.",
                                 text: $newToken
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
                 } */
                // 我是眼殘 把 .leading 看成 .loading ...
                Section {
                    VStack(alignment: .leading) {
                        if rest_Health.isLoading {
                            ProgressView()
                            // this is just to point a temp value for the if values to do stuff with. Awesome, no global vars are needed.
                        } else if let status = rest_Health.healthStatus {
                            HStack{
                                Spacer()
                                if status.status == "pass" {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 40))
                                        .tint(.green)
                                        .foregroundColor(.green)
                                } else {
                                    Image(systemName: "xmark.seal.fill")
                                        .font(.system(size: 40))
                                        .tint(.red)
                                        .foregroundColor(.green)
                                }
                                VStack{
                                    Text("Server Status \(status.status == "pass" ? "OK" : "Failed" )")
                                        .font(.system(size:20));
                                    if let version = status.version {
                                        Text("Version: \(version)").font(.system(size:15))
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .onAppear {
                        rest_Health.fetchHealthData(url: servers[0].url)
                    }
                }
                Section(header: Text("Add a new Domain")) {
                    VStack {
                        HStack {
                            TextField(
                                "The domain you want to add.",
                                text: $newDomain
                            )
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .token)
                            .onSubmit(pushNewServer)
                            Button(action: pushNewServer) {
                                Image(systemName: "plus")
                            }.disabled(newDomain.isEmpty)
                        }
                    }
                    // .padding(.vertical, 8)
                }
                Section(header: Text("Your Shlink Instances")) {
                    ForEach(servers) {
                        i in
                        HStack {
                            Text(i.url).font(.headline)
                        }
                    }.onDelete(perform: deleteServers)
                }
                Section(
                    header: Text("Other")
                ) {
                    NavigationLink(destination: PrivacyPolicyPage()) {
                        Label("How we use your data", systemImage: "lock.shield")
                    }
                    NavigationLink(destination: AboutPage()) {
                        Label("About this app", systemImage: "info.circle")
                    }
                }
                Section(
                    header: Text("The Danger Zone"),
                    footer: Text("Shlink iOS Manager v0.1.0").font(.footnote).foregroundStyle(.secondary)
                ) {
                    NavigationLink(destination: setNewToken()) {
                        Label("Update your auth token", systemImage: "key.fill")
                    }
                    .foregroundColor(.red)
                    .tint(.red)

                    // Use item for only an Item, use Items to export items.
                    ShareLink(item: exportJSON(path: "shlink_manager_export", encode: servers), preview: SharePreview("Export your Shlink Instances to a json file")) {
                        Label("Export your Shlink Instances", systemImage: "square.and.arrow.up")
                    }
                    .foregroundColor(.red)
                    .tint(.red)
                    /*
                     // Use item for only an Item, use Items to export items. (This apperenly now export TWO text dumps, when it should only give a .json file to the user.)
                     ShareLink(item: servers) {
                         server in SharePreview(
                                 "Shlink Instance: \(server.url)",
                                 image: "doc.text"
                         )
                     } label: {
                         Label("Export your Shlink Instances", systemImage: "square.and.arrow.up")
                     }
                     */
                    Button(action: {
                        showResetAlert = true
                    }) {
                        Label("Restart setup flow", systemImage: "restart.circle")
                    }
                    .foregroundColor(.red)
                    .tint(.red)
                }
            }
            /**.dismissKeyboardTap()*/
            .navigationTitle("Settings")
            .refreshable {
                updateDomains()
                rest_Health.fetchHealthData(url: servers[0].url)

            }
            .alert(
                "Reset your application",
                isPresented: $showResetAlert,
                actions: {
                    Button("Cancel", role: .cancel) {
                        showResetAlert = false
                    }
                    Button("Delete", role: .destructive) {
                        restartSetupFlow()
                    }
                },
                message: {
                    Text("Are your really sure? This reset every single setting you have in this application!")
                }
            )
            .alert(
                "Update your Shlink Token",
                isPresented: $showUpdateShlinkToken,
                actions: {
                    Button("Ok", role: .destructive) {}
                    Button("Delete", role: .destructive) {}
                }
            )
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
                  url.host != nil
            else {
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
            } catch {}
        }
    }

    private func pushNewServer() {}

    private func deleteServers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(servers[index])
            }
        }
    }

    private func updateDomains() {}

    private func restartSetupFlow() {
        exit(0)
    }

    // This coverts an array to a json file (btw the Array<T>'s T means it checks if it works with Encodable, and it will work on ANY I mean ANY array.) Ands it points to the temp URL of the newly created file.
    private func exportJSON<T: Encodable>(path: String, encode: [T]) -> URL {
        // Creates the encoder via the func JSONEncoder() (super easy to understand)
        let encoder = JSONEncoder()
        // This makes sure the JSON is formatted with proper indentation and line breaks (Comment this out later, this won't be needed)
        // encoder.outputFormatting = .prettyPrinted // Unneeded code
        //
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(path)
            .appendingPathExtension("json")
        do {
            let jsonData = try encoder.encode(encode)
            try jsonData.write(to: fileURL)
            return fileURL
        } catch {
            print(error)
            return fileURL
        }
    }
}
