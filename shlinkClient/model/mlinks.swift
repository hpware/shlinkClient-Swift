import Foundation
import SwiftData

// DONT USE STRUCT, IT WILL ABSOLUTELY BREAK THE APP.
@Model
final class MLinkModel {
    var shortURL: String
    var longURL: String
    var customSlug: String?
    var title: String?
    var visits: Int
    var createdAt: Date

    init(shortURL: String, longURL: String, customSlug: String? = nil, title: String? = nil) {
        self.shortURL = shortURL
        self.longURL = longURL
        self.customSlug = customSlug
        self.title = title
        visits = 0
        createdAt = Date()
    }
}
