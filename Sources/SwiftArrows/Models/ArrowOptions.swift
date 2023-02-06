//
//  ArrowOptions.swift
//  Arrows
//
//  Created by Purav Manot on 28/01/23.
//

import Foundation
import SwiftUI

public struct ArrowOptions: Hashable {
    public var bow, stretch, stretchMin, stretchMax, padStart, padEnd: CGFloat?
    public var flip, straights: Bool?
    
    public init(bow: CGFloat? = nil, stretch: CGFloat? = nil, stretchMin: CGFloat? = nil, stretchMax: CGFloat? = nil, padStart: CGFloat? = nil, padEnd: CGFloat? = nil, flip: Bool? = nil, straights: Bool? = nil) {
        self.bow = bow
        self.stretch = stretch
        self.stretchMin = stretchMin
        self.stretchMax = stretchMax
        self.padStart = padStart
        self.padEnd = padEnd
        self.flip = flip
        self.straights = straights
    }
}

public struct ArrowData {
    var start: CGPoint
    var control: CGPoint
    var end: CGPoint
    var startAngle: CGFloat
    var midAndle: CGFloat
    var endAngle: CGFloat
    
    public init(start: CGPoint, control: CGPoint, end: CGPoint, startAngle: CGFloat, midAndle: CGFloat, endAngle: CGFloat) {
        self.start = start
        self.control = control
        self.end = end
        self.startAngle = startAngle
        self.midAndle = midAndle
        self.endAngle = endAngle
    }
}
