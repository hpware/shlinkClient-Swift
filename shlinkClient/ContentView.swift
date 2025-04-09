import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            IndexPage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ViewAnalytics()
                .tabItem {
                    Image(systemName: "livephoto")
                    Text("Analytics")
                }
            HealthPage()
                .tabItem {
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
