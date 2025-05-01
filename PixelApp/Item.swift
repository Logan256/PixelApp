//
//  Item.swift
//  PixelApp
//
//  Created by Logan on 4/30/25.
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
