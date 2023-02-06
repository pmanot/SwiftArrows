//
//  Segment.swift
//  Arrows
//
//  Created by Purav Manot on 28/01/23.
//

import Foundation
import SwiftUI

public struct Segment: Hashable {
    var start: CGPoint
    var end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
    
    var vector: CGVector { self.end - self.start }
}

public extension Segment {
    func getIntersection(ray: Ray) -> CGPoint? {
        let r, s, d: CGFloat
        if (ray.dy * (self.end.x - self.start.x) != ray.dx * (self.end.y - self.start.y)) {
            d = ray.dx * (self.end.y - self.start.y) - ray.dy * (self.end.x - self.start.x)
            if (d != 0) {
                r = ((ray.origin.y - self.start.y) * (self.end.x - self.start.x) - (ray.origin.x - self.start.x) * (self.end.y - self.start.y)) / d
                s = ((ray.origin.y - self.start.y) * ray.dx - (ray.origin.x - self.start.x) * ray.dy) / d
                if (r >= 0 && s >= 0 && s <= 1) {
                    return CGPoint(x: ray.origin.x + r * ray.dx, y: ray.origin.y + r * ray.dy)
                }
            }
        }
        return nil
    }
    
    var length: CGFloat { getDistance(point1: start, point2: end) }
}

public extension Segment {
    static var zero: Self = Self.init(start: CGPoint.zero, end: CGPoint.zero)
}


