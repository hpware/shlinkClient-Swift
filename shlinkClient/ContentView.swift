import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var servers: [Server]
    @StateObject private var dataService = DataService()
    @State private var newServer = ""
    
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
    }

    private func addServer() {
        withAnimation {
            guard !newServer.isEmpty else { return }
            
            // Validate URL format
            guard let url = URL(string: newServer),
                  url.scheme != nil,
                  url.host != nil else {
                // TODO: Show error to user about invalid URL
                return
            }
            
            let server = Server(url: newServer)
            modelContext.insert(server)
            
            do {
                try modelContext.save()
                newServer = ""
                // Fetch initial health data
                Task {
                    await dataService.fetchHealthData(url: server.url)
                }
            } catch {
                // TODO: Show error to user about save failure
                print("Failed to save server: \(error)")
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
struct ServerStatusView: View{
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
