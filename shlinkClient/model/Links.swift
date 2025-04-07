import Foundation

struct LinkModel: Identifiable, Hashable {
    let id = UUID()
    var shortURL: String
    var title: String?
    var tags: [String]
    var visits: Int
    var status: String
    var createdAt: Date
    
    static func == (lhs: LinkModel, rhs: LinkModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
/*
It will be something like this 
let myLink = Link(
    shortURL: "https://yhw.tw/fef",
    title: "Cool",
    tags: ["no", "v"],
    visits: 3333,
    status: "active",
    createdAt: Date()
)
*/