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

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture
                {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
    }
}

extension View {
    func dismissKeyboardTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
