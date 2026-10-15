//
//  Item.swift
//  Programming_Assignment1
//
//  Created by Finn Goldmann on 08/10/2026.
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
