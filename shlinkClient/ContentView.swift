//
//  ContentView.swift
//  shlinkClient
//
//  Created by Howard Wu on 2025/4/4.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var dataService = DataService()
    
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
                } else if let status = dataService.healthStatus {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status: \(status.status)")
                            .font(.headline)
                        if let version = status.version {
                            Text("Version: \(version)")
                        }
                        
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
                        dataService.fetchHealthData()
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
            dataService.fetchHealthData()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
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

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
