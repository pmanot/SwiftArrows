//
//  CGPoint+Extensions.swift
//  Arrows
//
//  Created by Purav Manot on 31/01/23.
//

import Foundation
import SwiftUI

extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x - right.x, dy: left.y - right.y)
    }
    
    static func / (left: CGPoint, right: any BinaryInteger) -> CGPoint {
        return CGPoint(x: left.x / CGFloat(right), y: left.y / CGFloat(right))
    }
    
    func offset(_ axis: Axis, _ amount: CGFloat) -> CGPoint {
        switch axis {
            case .horizontal:
                return CGPoint(x: self.x + amount, y: self.y)
            case .vertical:
                return CGPoint(x: self.x, y: self.y + amount)
        }
    }
    
    func offset(_ amount: CGSize) -> CGPoint {
        CGPoint(x: self.x + amount.width, y: self.y + amount.height)
    }
}

extension CGPoint: Identifiable, Hashable {
    public var id: UUID { UUID() }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}
