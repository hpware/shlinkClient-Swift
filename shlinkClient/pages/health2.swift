import SwiftUI
import SwiftData

struct health2: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var servers: [Server]
    @StateObject private var dataService = DataService()
    @State private var newServer = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(
                    header: Text("Add server")
                    ) {
                HStack {
                    TextField(
                        "Server URL", 
                        text: $newServer
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onSubmit(addServer)
                Button(action: addServer) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(newServer.isEmpty);
                }
            } 
            Section(
                header: Text("Servers")
            ) {
                ForEach(servers)  {
                     i in 
                     // 欸幹我一直打錯字 87
                     ServerStatusView(server: i, dataService: dataService)
                }.onDelete(perform: deleteServers)
                }
            }.navigationTitle("Shlink Health")
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button(action: refreshAll) {
                        Label("Refresh All", systemImage: "arrow.clockwise")
                    }
                }
            }
            }.onAppear{
                print("Number of servers: \(servers.count)");
                servers.forEach { server in 
                print("Server URL: \(server.url)")}
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
    }
        private func addServer() {
        withAnimation {
            guard !newServer.isEmpty else { return }
            
            var urlString = newServer.trimmingCharacters(in: .whitespacesAndNewlines)
            if !urlString.hasSuffix("/rest/health") {
                if !urlString.hasSuffix("/") {
                    urlString += "/"
                }
                urlString += "rest/health"
            }
            
            if !urlString.contains("://") {
                urlString = "https://" + urlString
            }
            
            guard let url = URL(string: urlString),
                  url.scheme != nil,
                  url.host != nil else {
                errorMessage = "Please enter a valid server URL"
                showError = true
                return
            }
            print(urlString)
            let server = Server(url: urlString)
            print(server)
            print(server.url)
            print(modelContext.insert(server))            
            do {
                try modelContext.save()
                newServer = ""
                Task {
                    try? await dataService.fetchHealthData(url: server.url)
                }
            } catch {
                errorMessage = "Failed to save server: \(error.localizedDescription)"
                showError = true
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
    private func refreshAll() {
        print(servers)
        for i in servers {
            // Testing failed (I mean problem solving stuff)
            dataService.fetchHealthData(url: i.url)
        }
    }
}


// This is just react functions aka pages with extra steps. (struct)
//Swift 是一坨屎
//Swift 是一坨屎
//Swift 是一坨屎
//Swift 是一坨屎
//Swift 是一坨屎
struct asdad223223232: View{
        // Shit code.  Swift 是一坨屎
        /*withAnimation {
                                    Text("Status: \(server.status.status)")
                            .font(.headline)
                        if let version = server.status.version {
                            Text("Version: \(version)")
                        }
                        
                        Divider()
        }*/
        let server: Server
        @ObservedObject var dataService: DataService
        
        var body: some View {
            // 我是眼殘 把 .leading 看成 .loading ...
            VStack(alignment: .leading) {
                Text(server.url).font(.headline)
                if dataService.isLoading {
                    ProgressView()
                //       this is just to point a temp value for the if values to do stuff with. Awesome, no global vars are needed.
                } else if let status = dataService.healthStatus {
                    Text("Status: \(status.status)")
                    .font(.subheadline)
                    if let version = status.version {
                        Text("Version: \(version)").font(.caption)
                    }
                }
            }
                    .padding(.vertical, 4)
        .onAppear {
            dataService.fetchHealthData(url: server.url)
        }
        }
    }
