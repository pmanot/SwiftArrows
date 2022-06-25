//
//  CGPoint+Extensions.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 20/06/22.
//

import Foundation
import SwiftUI

extension CGPoint {
    init(_ x: Double, _ y: Double) {
        self.init(x: x, y: y)
    }
    
    init(from p1: CGPoint, displacement: CGFloat, gradient m: CGFloat){
        let changeX = displacement / sqrt(1 + m.magnitudeSquared)
        let changeY = m * changeX
        let point = p1 + CGPoint(x: changeX, y: changeY)
        self.init(x: point.x, y: point.y)
    }
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x/right, y: left.y/right)
    }
    
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x*right, y: left.y*right)
    }
}
