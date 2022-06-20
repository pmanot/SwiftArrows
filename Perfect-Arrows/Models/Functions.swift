//
//  Functions.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 18/06/22.
//

import Foundation
import SwiftUI

// MARK: - Arrow function

func getArrow(_ p1: CGPoint, _ p2: CGPoint, padding: CGFloat = 15, bow: CGFloat = 0.5) -> (CGPoint, CGPoint, CGPoint, Angle, Angle, Angle){
    let angle = getAngle(from: p1, to: p2)
    let distance = getDistance(from: p1, to: p2)
    let angliness = getAngliness(p1, p2)
    
    // Arrow is an arc
    let rot = (getSector(angle: angle).truncatingRemainder(dividingBy: 2) == 0 ? 1 : -1) * 1
    let arc = bow
    
    let control = getPointBetween(p1, p2, d: 0.5)
    let control2 = getPointBetween(p1, p2, d: 0.5 - arc)
    let rotatedPoint = rotatePoint(control2, around: control, angle: Angle(radians: (.pi / Double(2 * rot))))
    
    let a1 = getAngle(from: p1, to: rotatedPoint)
    let projectPoint1 = projectPoint(from: p1, angle: a1, distance: padding)
    
    let a2 = getAngle(from: p2, to: rotatedPoint)
    let projectPoint2 = projectPoint(from: p2, angle: a2, distance: padding)
    
    let aS = getAngle(from: rotatedPoint, to: p1)
    let aE = getAngle(from: rotatedPoint, to: p2)
    
    let paddedControl = getPointBetween(projectPoint1, projectPoint2, d: 0.5)
    let paddedControl2 = getPointBetween(projectPoint1, projectPoint2, d: 0.5 - arc)
    let paddedRotatedPoint = rotatePoint(paddedControl2, around: paddedControl, angle: Angle(radians: .pi / Double(2 * rot)))
    
    let avgControl = getPointBetween(rotatedPoint, paddedRotatedPoint, d: 0.5)
    
    return (projectPoint1, avgControl, projectPoint2, aE, aS, angle)
}


// MARK: - Helper functions

func modulate(value: CGFloat, rangeA: Range<CGFloat>, rangeB: Range<CGFloat>, clamp: Bool = false) -> CGFloat {
    let fromLow = rangeA.lowerBound,
        fromHigh = rangeA.upperBound,
        toLow = rangeB.lowerBound,
        toHigh = rangeB.upperBound
    
    let result = toLow + (value - fromLow) / (fromHigh - fromLow) * (toHigh - toLow)
    
    return result
    
}

func rotatePoint(_ p1: CGPoint, around p2: CGPoint, angle: Angle) -> CGPoint {
    let s = sin(angle.radians),
    c = cos(angle.radians)
    let change = p1 - p2
    let x = change.x * c - change.y * s,
        y = change.x * s + change.y * c
    return CGPoint(x: x + p2.x, y: y + p2.y)
}

func getDistance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
    return hypot(p2.y - p1.y, p2.x - p1.x)
}

func getAngle(from p1: CGPoint, to p2: CGPoint) -> Angle {
    return Angle(radians: atan2(p2.y - p1.y, p2.x - p1.x))
}

func projectPoint(from p1: CGPoint, angle: Angle, distance d: CGFloat) -> CGPoint {
    let s = sin(angle.radians),
    c = cos(angle.radians)
    
    return CGPoint(x: p1.x + c * d, y: p1.y + s * d)
}

func getPointBetween(_ p1: CGPoint, _ p2: CGPoint, d: CGFloat = 0.5) -> CGPoint {
    return CGPoint(x: p1.x + (p2.x - p1.x) * d, y: p1.y + (p2.y - p1.y) * d)
}


func getSector(angle: Angle, sectors s: Double = 8) -> Double {
    let a = angle.radians
    
    return floor(Double( s * (0.5 + (a / (.pi * 2)).truncatingRemainder(dividingBy: s))))
}

func getAngliness(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return abs((p2.x - p1.x) / 2 / ((p2.y - p1.y) / 2))
}

func doRectanglesCollide(r1: CGRect, r2: CGRect) -> Bool {
    return !(r1.midX >= r2.midX + r2.width || r2.midX >= r1.midX + r1.width || r1.midY >= r2.midY + r2.height || r2.midY >= r1.midY + r1.height)
}

func getSegmentCircleIntersections(origin c: CGPoint, radius r: CGFloat, startPoint p1: CGPoint, change delta: CGPoint) -> [CGPoint]{
    let v1 = CGPoint(x: delta.x - p1.x, y: delta.y - p1.y),
        v2 = CGPoint(x: p1.x - c.x, y: p1.y - c.y)
    
    var b = v1.x * v2.x + v1.y * v2.y
    let c = 2 * v1.x * v1.x + v1.y * v1.y
    b = (b * -2)
    let d = sqrt(b * b - 2 * c * (v2.x * v2.x + v2.y * v2.y - r * r))
    
    if d.isNaN {
        return []
    }
    
    var points: [CGPoint] = []
    
    let d1 = (b - d) / c,
        d2 = (b + d) / c
    
    if (d1 <= 1 && d1 >= 0) {
        // add point if on the line segment
        points.append(CGPoint(x: p1.x + v1.x * d1, y: p1.y + v1.y * d1))
    }

    if (d2 <= 1 && d2 >= 0) {
        // second add point if on the line segment
        points.append(CGPoint(x: p1.x + v1.x * d2, y: p1.y + v1.y * d2))
    }
    
    return points
}

func normalizeAngle(angle: Angle) -> Angle {
    let radians = angle.radians
    return Angle(radians: (radians - .pi * 2 * floor(radians / (.pi * 2))))
}
