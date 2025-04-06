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
