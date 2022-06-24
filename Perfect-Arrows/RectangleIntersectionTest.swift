//
//  RectangleIntersectionTest.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 23/06/22.
//

import Foundation
import SwiftUI

struct RectangleIntersectionTest: View {
    let rect1 = CGRect(x: 150, y: 300, width: 200, height: 200)
    let rect2 = CGRect(x: 200, y: 275, width: 0, height: 140)
    let point1 = CGPoint(x: 250, y: 350)
    let point2 = CGPoint(x: 300, y: 500)
    var change: CGPoint {
        point2 - point1
    }
    var intersection: CGPoint {
        getRaySegmentIntersection(rayOrigin: point1, delta: change, segmentStartPoint: CGPoint(x: rect1.minX, y: rect1.minY), segmentEndPoint: CGPoint(x: rect1.maxX, y: rect1.minY)) ?? CGPoint.zero
    }
    var body: some View {
        ZStack {
            CGRectangle(rect1)
            CurvedLine(point1, point2, control: (point1 + point2)/2)
                .stroke(lineWidth: 2)
            Circle()
                .frame(width: 10, height: 10)
                .position(x: intersection.x, y: intersection.y)
        }
        
    }
}

struct RectangleIntersectionTest_Previews: PreviewProvider {
    static var previews: some View {
        RectangleIntersectionTest()
    }
}


extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
}

struct CGRectangle: View {
    let rect: CGRect
    init(_ rect: CGRect){
        self.rect = rect
    }
    var body: some View {
        Rectangle()
            .stroke()
            .frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
    }
}
