import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            HealthPage()
            .tabItem() {
                Image(systemName: "bolt.heart")
                Text("Health")
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
