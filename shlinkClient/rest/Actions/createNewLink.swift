import Foundation

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

    func pushNewLink(_ p: createNewLink?) {
        // Use _ for intentionally unused components
        _ = p?.long
        _ = p?.shortCodeLength
        _ = p?.title
        _ = p?.startDate
        _ = p?.endDate
        _ = p?.domain
        _ = p?.maxVisits
        _ = p?.crawlable
        _ = p?.forwardParam
        _ = p?.useExisting

        var domain = ""
        if p?.domain == nil {
            domain = pullBaseDomain()
        } else {
            // Use ! for value stuff
            domain = p!.domain!
        }

        let endPoint = domain.hasSuffix("/") ? "rest/v3/short-urls" : "/rest/v3/short-urls"
        let domainMergePoint = domain + endPoint
        guard let domainMergePoint = URL(string: domainMergePoint) else {
            errormsg = "There is an error in the process"
            print(errormsg)
            return
        }
    }
}
