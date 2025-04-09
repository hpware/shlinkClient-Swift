import Foundation
import SwiftData

@Model
final class Server {
    var url: String
    var timestamp: Date
    // Every new store stores like this
    /*
         {
             url: "https://yhw.tw/",
             timestamp: (Just a date)
         }
     */
    init(url: String) {
        self.url = url
        timestamp = Date()
    }
}
