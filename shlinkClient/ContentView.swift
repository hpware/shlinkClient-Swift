import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            IndexPage()
            .tabItem() {
                Image(systemName: "house")
                Text("Health")
            }
            HealthPage()
            .tabItem() {
                Image(systemName: "bolt.heart")
                Text("Status")
            }
            SettingsPage()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
