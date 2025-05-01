import Foundation

struct ShortURLPayload: Codable {
    let longUrl: String
    let slug: String?
    let title: String?
    let tags: [String]?
    let crawlable: Bool
    let forwardQuery: Bool
    let findIfExists: Bool
}

struct createNewLink: Codable, Identifiable {
    var id = UUID()
    var long: String
    var slug: String?
    var shortCodeLength: Int?
    var title: String?
    var startDate: Date?
    var endDate: Date?
    var domain: String?
    // Use int instead of Number
    var maxVisits: Int?
    // Use Bool instead of boolean
    var crawlable: Bool
    var forwardParam: Bool
    var useExisting: Bool
    var tags: [String]?

    enum createNewLinkKeys: String, CodingKey {
        case slug
        case long
        case shortCodeLength
        case title
        case startDate
        case endDate
        case domain
        case maxVisits
        case crawlable
        case forwardParam
        case useExisting
    }
}

class createNewLinkRest: ObservableObject {
    @Published var createNewLink: createNewLink?
    @Published var isLoading = false
    @Published var errormsg = ""

    func pushNewLink(_ p: createNewLink?) async throws -> Bool {
        guard let p else { return false }

        var domain = ""
        if p.domain == nil {
            domain = pullBaseDomain()
        } else {
            // Use ! for value stuff
            domain = p.domain!
        }

        let endPoint = domain.hasSuffix("/") ? "rest/v3/short-urls" : "/rest/v3/short-urls"
        let domainMergePoint2 = domain + endPoint
        guard let domainMergePoint = URL(string: domainMergePoint2) else {
            errormsg = "There is an error in the process"
            print(errormsg)
            return errormsg
        }
        var request = URLRequest(url: domainMergePoint)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        let payload = ShortURLPayload(
            longUrl: p.long,
            slug: p.slug,
            title: p.title,
            tags: p.tags,
            crawlable: p.crawlable,
            forwardQuery: p.forwardParam,
            findIfExists: p.useExisting
        )

        do {
            let data = try encoder.encode(payload)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Encoded JSON: \(jsonString)")
            }
            request.httpBody = data
        } catch {
            print("An error occurred during encoding: \(error)")
        }
    }
}
