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
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
