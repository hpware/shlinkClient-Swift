import SwiftUI
import SwiftData

@main
struct ShlinkClientApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Server.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}