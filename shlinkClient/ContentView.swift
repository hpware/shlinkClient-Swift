import SwiftUI
import SwiftData

@Model 
class Server {
    var url: string,
    var timestamp: Date
    // Every new store stores like this 
    /*
        {
            url: "https://yhw.tw/",
            timestamp: (Just a date)
        }
    */
    init(url: String) {
        self.url = url
        self.timestamp = Date()
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var servrers: [Server]
    @StateObject private var dataService = DataService()
    @State private var newserver = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if dataService.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = dataService.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()

                        Divider()
                         TextField(
                            "Input Server Domain",
                            text: $server
                        ).onSubmit{
                            dataService.fetchHealthData(url: server) 
                        }.textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .border(.secondary)

                } else if let status = dataService.healthStatus {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status: \(status.status)")
                            .font(.headline)
                        if let version = status.version {
                            Text("Version: \(version)")
                        }
                        
                        Divider()
                        TextField(
                            "Input Server Domain",
                            text: $server
                        ).onSubmit{
                            dataService.fetchHealthData(url: server) 
                        }.textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .border(.secondary)

                        Divider()
                        // Also show your existing items
                        List {
                            ForEach(items) { item in
                                Text(item.timestamp.formatted())
                            }
                            .onDelete(perform: deleteItems)
                        }
                    }
                    .padding()
                } else {
                    Text("Tap Refresh to check the service status")
                        .padding()
                }
            }
            .navigationTitle("Shlink Health")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                     if server.isEmpty {
                    dataService.fetchHealthData(url: server)
            }  
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .onAppear {
            if server.isEmpty {
                dataService.fetchHealthData(url: server)
            }  
        }
    }

    private func addItem() {
        withAnimation {
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}