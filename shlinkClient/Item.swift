//
//  Item.swift
//  shlinkClient
//
//  Created by Howard Wu on 2025/4/4.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
