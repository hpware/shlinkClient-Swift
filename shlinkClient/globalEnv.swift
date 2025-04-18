import SwiftData
import SwiftUI

@Observable
// Make Global Store a Observable Object, ig
final class GlobalStore: ObservableObject {
    static let shared = GlobalStore()
    // Don't make the private init go into to other values

    // And publish it, ok this is ridiculous
    @Published @ObservationIgnored var mainServer: String {
        didSet {
            UserDefaults.standard.set(mainServer, forKey: "shlinkMainServer")
        }
    }
    @Published @ObservationIgnored var token: String {
        didSet {
            // Save the token whenever it changes
            UserDefaults.standard.set(token, forKey: "shlinkAuthToken")
        }
    }
    @Published @ObservationIgnored var healthStatus: Bool = false

    private init() {
        self.mainServer = UserDefaults.standard.string(forKey: "shlinkMainServer") ?? ""
        self.token = UserDefaults.standard.string(forKey: "shlinkToken") ?? ""
    }
}
