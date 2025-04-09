import Foundation
import SwiftData

import CoreTransferable

// Import Transferable Lib
import UniformTypeIdentifiers

@Model
final class Server: Transferable, Codable {
    var url: String
    var timestamp: Date
    // var accessToken: String
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

    /*
         * This is used to map the items during the encoding & decoding process.
     */
    enum CodingKeys: CodingKey {
        case url
        case timestamp
    }

    // Decodes
    // required means all subclasses must use this init, and is part of the decoding protocol process
    required init(from decoder: Decoder) throws {
        // creating a decoding container using the CodingKeys enum, and the containter provides structured access to the JSON data **TRY TO**
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // this is property decoding. each line decodes a specific property from the JSON (you must follow the CodingKeys enum)
        url = try container.decode(String.self, forKey: .url)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    // Example JSON output:
    /*
         {
             "url": "https://yy.ff.dd",
             "timestamp: "2024-04-03T10:00:00Z"
         }
     */
    // Also later on this must include the token, this token can try be encoded? to protect the token from getting leaked. And while importing, the importing device will decode the encoded token.

    // Encodes
    // to encoder: Encoder => is required by the Encodable protocol (the captital E is the required one)
    func encode(to encoder: Encoder) throws {
        // creates a mutable encoding container, and uses CodingKeys enum for structered encoding, and this container manages the JSON key-value pairs.
        var container = encoder.container(keyedBy: CodingKeys.self)
        // This for property encoding. Each line is it's own specific property. (Follow CodingKeys enum)
        try container.encode(url, forKey: .url)
        try container.encode(timestamp, forKey: .timestamp)
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
    }
}
