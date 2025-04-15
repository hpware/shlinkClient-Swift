import SwiftData
import SwiftUI

@Observable
// Make Global Store a Observable Object, ig
final class GlobalStore: ObservableObject {
    static let shared = GlobalStore()
    // Don't make the private init go into to other values

    // And publish it, ok this is ridiculous
    @Published @ObservationIgnored var mainServer: String = ""
    @Published @ObservationIgnored var token: String = ""
    @Published @ObservationIgnored var healthStatus: Bool = false

    private init() {}
}
