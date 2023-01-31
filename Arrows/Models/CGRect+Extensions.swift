//
//  CGRect+Extensions.swift
//  Arrows
//
//  Created by Purav Manot on 31/01/23.
//

import Foundation

extension CGRect {
    func getRectangleSegments() -> [Segment] {
        let x = self.origin.x
        let y = self.origin.y
        let w = self.size.width
        let h = self.size.height
        
        return [
            Segment(start: CGPoint(x: x, y: y), end: CGPoint(x: x + w, y: y)),
            Segment(start: CGPoint(x: x + w, y: y), end: CGPoint(x: x + w, y: y + h)),
            Segment(start: CGPoint(x: x + w, y: y + h), end: CGPoint(x: x, y: y + h)),
            Segment(start: CGPoint(x: x, y: y + h), end: CGPoint(x: x, y: y))
        ]
    }
    
    func getRoundedRectangleSegments(r: CGFloat) -> [Segment] {
        let x = origin.x
        let y = origin.y
        let w = size.width
        let h = size.height
        
        let rx = x + r,
            ry = y + r,
            mx = x + w,
            my = y + h,
            mrx = x + w - r,
            mry = y + h - r
        
        return [
            Segment(start: CGPoint(x: x, y: mry), end: CGPoint(x: x, y: ry)),
            Segment(start: CGPoint(x: x, y: ry), end: CGPoint(x: x, y: y)),
            Segment(start: CGPoint(x: rx, y: y), end: CGPoint(x: mrx, y: y)),
            Segment(start: CGPoint(x: mrx, y: y), end: CGPoint(x: mx, y: y)),
            Segment(start: CGPoint(x: mx, y: ry), end: CGPoint(x: mx, y: mry)),
            Segment(start: CGPoint(x: mx, y: mry), end: CGPoint(x: mx, y: my)),
            Segment(start: CGPoint(x: mrx, y: my), end: CGPoint(x: rx, y: my)),
            Segment(start: CGPoint(x: rx, y: my), end: CGPoint(x: x, y: my))
        ]
    }
    
    var vertices: [CGPoint] {
        let halfWidth = self.width/2
        let halfHeight = self.height/2
        
        return [
            self.origin.offset(CGSize(width: halfWidth, height: -halfHeight)),
            self.origin.offset(CGSize(width: -halfWidth, height: halfHeight)),
            self.origin.offset(CGSize(width: -halfWidth, height: -halfHeight)),
            self.origin.offset(CGSize(width: halfWidth, height: halfHeight))
        ]
    }
    
    var midPoints: [CGPoint] {
        let halfWidth = self.width/2
        let halfHeight = self.height/2
        
        return [
            self.origin.offset(.horizontal, halfWidth),
            self.origin.offset(.horizontal, -halfWidth),
            self.origin.offset(.vertical, halfHeight),
            self.origin.offset(.vertical, -halfHeight)
        ]
    }
    
    var center: CGPoint { CGPoint(x: self.midX, y: self.midY) }
}
