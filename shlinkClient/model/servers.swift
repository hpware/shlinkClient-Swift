import SwiftData
import Foundation

@Model 
class Server {
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
        self.timestamp = Date()
    }
}
