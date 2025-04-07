import Foundation

struct createNewLink: Codable, Identifiable {
    var id = UUID()
    var slug: String?

    enum createNewLinkKeys: String, CodingKey {
        case slug
    }
}