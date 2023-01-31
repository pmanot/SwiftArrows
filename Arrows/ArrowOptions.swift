//
//  ArrowOptions.swift
//  Arrows
//
//  Created by Purav Manot on 28/01/23.
//

import Foundation
import SwiftUI

struct ArrowOptions: Hashable {
    var bow, stretch, stretchMin, stretchMax, padStart, padEnd: CGFloat?
    var flip, straights: Bool?
}

struct ArrowData: Hashable {
    var start: CGPoint
    var control: CGPoint
    var end: CGPoint
    var startAngle: CGFloat
    var midAndle: CGFloat
    var endAngle: CGFloat
}
