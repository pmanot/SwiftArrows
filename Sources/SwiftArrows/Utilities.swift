//
//  Utilities.swift
//  Arrows
//
//  Created by Purav Manot on 28/01/23.
//

import Foundation
import SwiftUI

public struct Math {
    public static var pi: CGFloat = .pi
    public static var halfPi: CGFloat = .pi/2
    public static var minimumAngle: CGFloat = .pi/24
}

public func modulate(value: Double, from rangeA: (Double, Double), to rangeB: (Double, Double), clamp: Bool = false) -> Double {
    // calculate the result by multiplying the value by the ratio of the rangeB and rangeA
    let result = rangeB.0 + ((value - rangeA.0) / (rangeA.1 - rangeA.0)) * (rangeB.1 - rangeB.0)
    
    // if clamp is true, check if the result is within rangeB and return the result or the closest value in rangeB
    if clamp == true {
        if rangeB.1 > rangeB.0 {
            if result < rangeB.0 {
                return rangeB.0
            }
            if result > rangeB.1 {
                return rangeB.1
            }
        } else {
            if result > rangeB.0 {
                return rangeB.0
            }
            if result < rangeB.1 {
                return rangeB.1
            }
        }
    }
    return result
}

public func rotate(point: CGPoint, center: CGPoint, angle: Double) -> CGPoint {
    let s = sin(angle)
    let c = cos(angle)
    
    // create CGPoint for original point offset from center
    let p = CGPoint(x: point.x - center.x, y: point.y - center.y)
    
    // create CGPoint for rotated point
    let n = CGPoint(x: p.x * c - p.y * s, y: p.x * s + p.y * c)
    
    // return the new point with the center point added
    return CGPoint(x: n.x + center.x, y: n.y + center.y)
}

public func getDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    // use the Pythagorean theorem to calculate the distance between two points
    return hypot(point1.y - point2.y, point1.x - point2.x)
}

public func getAngle(point1: CGPoint, point2: CGPoint) -> CGFloat {
    // use atan2 to calculate the angle between two points
    return atan2(point2.y - point1.y, point2.x - point1.x)
}

public func projectPoint(point: CGPoint, angle: CGFloat, distance: CGFloat) -> CGPoint {
    // use trigonometry to calculate the new x and y values by projecting the point a certain distance at a certain angle
    let x = cos(angle) * distance + point.x
    let y = sin(angle) * distance + point.y
    return CGPoint(x: x, y: y)
}

public func getPointBetween(point1: CGPoint, point2: CGPoint, distance: CGFloat = 0.5) -> CGPoint {
    // calculate the x and y values between two points by multiplying the difference by a certain distance
    let x = point1.x + (point2.x - point1.x) * distance
    let y = point1.y + (point2.y - point1.y) * distance
    return CGPoint(x: x, y: y)
}

public func getSector(angle: Double, segments: Int = 8) -> Int {
    // calculate the sector of an angle by dividing it by the total angle (2 * pi) and rounding down
    return Int(floor(CGFloat(segments) * (0.5 + ((angle / (.pi * 2)).truncatingRemainder(dividingBy: CGFloat(segments))))))
}

public func getAngliness(point1: CGPoint, point2: CGPoint) -> CGFloat {
    // calculate the ratio of the difference between x values to the difference between y values
    return abs(((point2.x - point1.x) / 2) / ((point2.y - point1.y) / 2))
}

public func getRaySegmentIntersection(ray: Ray, segment: Segment) -> CGPoint? {
    let r, s, d: CGFloat

    if (ray.dy * (segment.end.x - segment.start.x) != ray.dx * (segment.end.y - segment.start.y)) {
        d = ray.dx * (segment.end.y - segment.start.y) - ray.dy * (segment.end.x - segment.start.x)
        if (d != 0) {
            r = ((ray.origin.y - segment.start.y) * (segment.end.x - segment.start.x) - (ray.origin.x - segment.start.x) * (segment.end.y - segment.start.y)) / d
            s = ((ray.origin.y - segment.start.y) * ray.dx - (ray.origin.x - segment.start.x) * ray.dy) / d
            if (r >= 0 && s >= 0 && s <= 1) {
                return CGPoint(x: ray.origin.x + r * ray.dx, y: ray.origin.y + r * ray.dy)
            }
        }
    }
    return nil
}

public func getDelta(angle: Double) -> CGVector {
    // return the x and y delta values of the angle
    return CGVector(dx: cos(angle), dy: sin(angle))
}

public func getIntermediate(angle: Double) -> Double {
    // calculate the intermediate value of the angle relative to a right angle
    return abs(abs(angle.truncatingRemainder(dividingBy: Double.pi / 2)) - Double.pi / 4) / (Double.pi / 4)
}

public func normalizeAngle(radians: Double) -> Double {
    return radians - Double.pi * 2 * floor(radians / (Double.pi * 2))
}

public func getSegmentSegmentIntersection(segment1: Segment, segment2: Segment) -> CGPoint? {
    let delta1: CGVector = segment1.end - segment1.start
    let delta2: CGVector = segment2.end - segment2.start
    
    // Calculate the denominator of the equation for finding the intersection
    let denom = delta2.dy * delta1.dx - delta2.dx * delta1.dy
    
    // If the denominator is 0, the segments are either parallel or collinear
    if denom == 0 {
        // Calculate the numerator of the equation for each segment
        let numeratorA = delta2.dx * (segment1.start.y - segment2.start.y) - delta2.dy * (segment1.start.x - segment2.start.x)
        let numeratorB = delta1.dx * (segment1.start.y - segment2.start.y) - delta1.dy * (segment1.start.x - segment2.start.x)
        
        // If both numerators are 0, the segments are collinear
        if numeratorA == 0 && numeratorB == 0 {
            return nil // Collinear
        }
        return nil // Parallel
    }
    
    // Calculate the value of the parameter for each segment
    let parameterA = (delta2.dx * (segment1.start.y - segment2.start.y) - delta2.dy * (segment1.start.x - segment2.start.x)) / denom
    let parameterB = (delta1.dx * (segment1.start.y - segment2.start.y) - delta1.dy * (segment1.start.x - segment2.start.x)) / denom
    
    // If the value of both parameters are between 0 and 1, the segments intersect
    if parameterA >= 0 && parameterA <= 1 && parameterB >= 0 && parameterB <= 1 {
        // Calculate the intersection point
        let intersection = segment1.start + CGPoint(x: delta1.dx * parameterA, y: delta1.dy * parameterA)
        return intersection
    }
    
    return nil // No intersection
}

public func getSegmentCircleIntersections(circleCenter: CGPoint, radius: CGFloat, start: CGPoint, end: CGPoint) -> [CGPoint] {
    let v1 = CGVector(dx: end.x - start.x, dy: end.y - start.y)
    let v2 = CGVector(dx: start.x - circleCenter.x, dy: start.y - circleCenter.y)
    
    var b: CGFloat = v1.dx * v2.dx + v1.dy * v2.dy
    let c: CGFloat = 2 * (v1.dx * v1.dx + v1.dy * v1.dy)
    b *= -2
    let d = sqrt(b * b - 2 * c * (v2.dx * v2.dx + v2.dy * v2.dy - radius * radius))
    
    if d.isNaN {
        // no intercept
        return []
    }
    
    let u1: CGFloat = (b - d) / c
    let u2: CGFloat = (b + d) / c
    var intersections: [CGPoint] = []
    
    if (u1 <= 1 && u1 >= 0) {
        // add point if on the line segment
        intersections.append(CGPoint(x: start.x + v1.dx * u1, y: start.y + v1.dy * u1))
    }
    
    if (u2 <= 1 && u2 >= 0) {
        // second add point if on the line segment
        intersections.append(CGPoint(x: start.x + v1.dx * u2, y: start.y + v1.dy * u2))
    }
    
    return intersections
}

public func getSegmentRoundedRectangleIntersectionPoints(segment: Segment, rectangle: CGRect, radius: CGFloat) -> [CGPoint] {
    let x = rectangle.origin.x,
        y = rectangle.origin.y,
        mx = rectangle.maxX,
        my = rectangle.maxY,
        rx = rectangle.minX + radius,
        ry = rectangle.minY + radius,
        mrx = rectangle.maxX - radius,
        mry = rectangle.maxY - radius
    
    let segments = [
        (Segment(start: CGPoint(x: x, y: mry), end: CGPoint(x: x, y: ry)), CGPoint(x: x, y: y)),
        (Segment(start: CGPoint(x: rx, y: y), end: CGPoint(x: mrx, y: y)), CGPoint(x: mx, y: y)),
        (Segment(start: CGPoint(x: mx, y: ry), end: CGPoint(x: mx, y: mry)), CGPoint(x: mx, y: my)),
        (Segment(start: CGPoint(x: mrx, y: mry), end: CGPoint(x: rx, y: my)), CGPoint(x: x, y: my)),
    ]
    
    let corners = [
        (CGPoint(x: rx, y: ry), .pi, .pi * 1.5),
        (CGPoint(x: mrx, y: ry), .pi * 1.5, .pi * 2),
        (CGPoint(x: mrx, y: mry), 0, .pi * 0.5),
        (CGPoint(x: rx, y: mry), .pi, .pi)
    ]
    
    var points: [CGPoint] = []
    
    for i in 0..<4 {
        let s = segments[i].0
        let corner = corners[i]
        
        let intersections = getSegmentCircleIntersection(segment: s, circleOrigin: corner.0, radius: radius)
            .filter { point in
                let pointAngle = normalizeAngle(radians: getAngle(point1: corner.0, point2: point))
                return (pointAngle > corner.1 && pointAngle < corner.2)
            }
        points.append(contentsOf: intersections)
        
        if let segmentIntersection = getSegmentSegmentIntersection(segment1: segment, segment2: s) {
            points.append(segmentIntersection)
        }
    }
    
    return points
}

public func getSegmentCircleIntersection(segment: Segment, circleOrigin: CGPoint, radius: CGFloat) -> [CGPoint] {
    var b, c, d, u1, u2: CGFloat
    var result: [CGPoint] = []
    let vector1: CGVector = segment.vector
    let vector2: CGVector = segment.start - circleOrigin
    
    b = (vector1.dx * vector2.dx) + (vector1.dy * vector2.dy)
    c = 2 * (vector1.dx.magnitudeSquared + vector1.dy.magnitudeSquared)
    b *= -2
    d = sqrt(b * b - 2 * c * (vector2.dx.magnitudeSquared + vector2.dy.magnitudeSquared - radius.magnitudeSquared))
    if d.isNaN {
        // no intercept
        return []
    }
    
    u1 = (b - d)/c
    u2 = (b + d)/c
    
    if (u1 <= 1 && u1 >= 0) {
        result.append(CGPoint(x: segment.start.x + vector1.dx * u1, y: segment.start.y + vector1.dy * u1))
    }
    
    if (u2 <= 1 && u2 >= 0) {
        result.append(CGPoint(x: segment.start.x + vector1.dx * u2, y: segment.start.y + vector1.dy * u2))
    }
    
    return result
}

public func getRayCircleIntersection(ray: Ray, circleOrigin: CGPoint, radius: CGFloat) -> [CGPoint] {
    getSegmentCircleIntersection(segment: Segment(start: ray.origin, end: CGPoint(x: ray.dx * 999999, y: ray.dy * 999999)), circleOrigin: circleOrigin, radius: radius)
}


public func getRayRoundedRectangleIntersection(ray: Ray, rectangle: CGRect, radius: CGFloat) -> [CGPoint] {
    let mx = rectangle.maxX,
        my = rectangle.maxY,
        rx = rectangle.minX + radius - 1,
        ry = rectangle.minY + radius - 1,
        mrx = rectangle.maxX - radius + 1,
        mry = rectangle.maxY - radius + 1
    
    let segments = [
        Segment(start: CGPoint(x: rectangle.minX, y: mry), end: CGPoint(x: rectangle.minX, y: ry)),
        Segment(start: CGPoint(x: rx, y: rectangle.minY), end: CGPoint(x: mrx, y: rectangle.minY)),
        Segment(start: CGPoint(x: mx, y: ry), end: CGPoint(x: mx, y: mry)),
        Segment(start: CGPoint(x: mrx, y: my), end: CGPoint(x: rx, y: my))
    ]
    
    let corners = [
        (CGPoint(x: rx, y: ry), CGFloat.pi, CGFloat.pi * 1.5),
        (CGPoint(x: mrx, y: ry), CGFloat.pi * 1.5, CGFloat.pi * 2),
        (CGPoint(x: mrx, y: mry), 0, CGFloat.pi * 0.5),
        (CGPoint(x: rx, y: mry), CGFloat.pi * 0.5, CGFloat.pi),
    ]
    
    var points: [CGPoint] = []
    
    segments.forEach { segment in
        if let intersection = getRaySegmentIntersection(ray: ray, segment: segment) {
            points.append(intersection)
        }
    }
    
    for corner in corners {
        let (angleStart, angleEnd) = (corner.1, corner.2)
        
        
        let intersections = getRayCircleIntersection(ray: ray, circleOrigin: corner.0, radius: radius)
        
        intersections.forEach { intersection in
            let pointAngle = normalizeAngle(radians: getAngle(point1: corner.0, point2: intersection))
            if pointAngle > angleStart && pointAngle < angleEnd {
                points.append(intersection)
            }
        }
    }
    
    return points
}

public func getLineBetweenRoundedRectangles(rect1: CGRect, radius1: CGFloat, rect2: CGRect, radius2: CGFloat) -> Segment {
    
    let direct1 = getRayRoundedRectangleIntersection(ray: Ray(origin: rect1.center, direction: rect2.center - rect1.center), rectangle: rect1, radius: radius1).first ?? CGPoint.zero
    let direct2 = getRayRoundedRectangleIntersection(ray: Ray(origin: rect2.center, direction: rect1.center - rect2.center), rectangle: rect2, radius: radius2).first ?? CGPoint.zero
    
    return Segment(start: direct1, end: direct2)
}

public func getRayRectangleIntersectionPoints(ray: Ray, rect: CGRect) -> [CGPoint] {
    let segments = rect.getRectangleSegments()
    return segments.compactMap { $0.getIntersection(ray: ray) }
}

public func getRectangleSegmentIntersectedByRay(ray: Ray, rect: CGRect) -> Segment? {
    for segment in rect.getRectangleSegments() {
        if getRaySegmentIntersection(ray: ray, segment: segment) != nil {
            return segment
        }
    }
    
    return nil
}

public func getArrow(from point1: CGPoint, to point2: CGPoint, options: ArrowOptions = ArrowOptions()) -> (CGPoint, CGPoint, CGPoint, CGFloat, CGFloat, CGFloat) {
    let angle = getAngle(point1: point1, point2: point2)
    let distance = getDistance(point1: point1, point2: point2)
    let angliness = getAngliness(point1: point1, point2: point2)
    let padStart = options.padStart ?? 0
    let padEnd = options.padEnd ?? 0
    let bow = options.bow ?? 0
    let stretch = options.stretch ?? 0.5
    let stretchMin = options.stretchMin ?? 0
    let stretchMax = options.stretchMax ?? 420
    let flip = options.flip ?? true
    let straights = options.straights ?? true
    
    
    if (distance < (padStart + padEnd) * 2) || (bow == 0 && stretch == 0) || (straights && [0, 1, .infinity].contains(angliness)) {
        let pStart = max(0, min(distance - padStart, padStart))
        let pEnd = max(0, min(distance - pStart, padEnd))
        
        let start = projectPoint(point: point1, angle: angle, distance: pStart)
        let end = projectPoint(point: point2, angle: angle + .pi, distance: pEnd)
        let mid = getPointBetween(point1: start, point2: end, distance: 0.5)
        
        return (start, mid, end, angle, angle, angle)
    }
    
    let rotation: Double = (getSector(angle: angle) % 2 == 0 ? 1 : -1) * (flip ? -1 : 1)
    let arc = bow + modulate(value: distance, from: (stretchMin, stretchMax), to: (1, 0), clamp: true) * stretch
    let mid1 = getPointBetween(point1: point1, point2: point2, distance: 0.5)
    var control1 = getPointBetween(point1: point1, point2: point2, distance: 0.5 - arc)
    control1 = rotate(point: control1, center: mid1, angle: (Math.halfPi)*rotation)
    
    let angle1 = getAngle(point1: point1, point2: control1)
    let angle2 = getAngle(point1: point2, point2: control1)
    
    let start = projectPoint(point: point1, angle: angle1, distance: padStart)
    let end = projectPoint(point: point2, angle: angle2, distance: padEnd)
    
    let startAngle = getAngle(point1: control1, point2: point1)
    let endAngle = getAngle(point1: control1, point2: point2)
    
    let mid2 = getPointBetween(point1: start, point2: end, distance: 0.5)
    
    var control2 = getPointBetween(point1: start, point2: end, distance: 0.5 - arc)
    control2 = rotate(point: control2, center: mid2, angle: (Math.halfPi)*rotation)
    
    let control = getPointBetween(point1: control1, point2: control2, distance: 0.5)
    
    return (start, control, end, endAngle, startAngle, angle)
}


public func getBoxToBoxArrow(from rect1: CGRect, to rect2: CGRect, options: ArrowOptions = ArrowOptions()) -> (CGPoint, CGPoint, CGPoint, CGFloat, CGFloat, CGFloat) {
    let padStart = options.padStart ?? 0
    let padEnd = options.padEnd ?? 0
    let bow = options.bow ?? 0
    let stretch = options.stretch ?? 0.5
    let stretchMin = options.stretchMin ?? 0
    let stretchMax = options.stretchMax ?? 420
    let flip = options.flip ?? true
    let straights = options.straights ?? true
    
    let paddedRect1 = rect1.inset(by: UIEdgeInsets(top: -padStart, left: -padStart, bottom: -padStart, right: -padStart))
    let paddedRect2 = rect2.inset(by: UIEdgeInsets(top: -padEnd, left: -padEnd, bottom: -padEnd, right: -padEnd))
    
    let angle = normalizeAngle(radians: getAngle(point1: rect1.center, point2: rect2.center))
    let distance = getDistance(point1: rect1.center, point2: rect2.center)
    
    if distance == 0 {
        let start = CGPoint(x: rect1.midX, y: rect1.origin.y)
        let end = CGPoint(x: rect2.midX, y: rect2.origin.y)
        let control = getPointBetween(point1: start, point2: end, distance: 0.5)
        let controlAngle = getAngle(point1: start, point2: end)
        
        return (start, end, control, controlAngle, controlAngle, controlAngle)
    }
    
    let rotation: Double = (getSector(angle: angle) % 2 == 0 ? 1 : -1) * (flip ? -1 : 1)
    var card = getIntermediate(angle: angle)
    if (card < 1 && card > 0.85) { card = 0.99 }
    
    let isColliding = rect1.intersects(rect2)
    
    let directLine = getLineBetweenRoundedRectangles(rect1: paddedRect1, radius1: padStart, rect2: paddedRect2, radius2: padEnd)
    
    let distanceBetween = directLine.length
    
    if (!isColliding && straights && card.truncatingRemainder(dividingBy: 0.5) == 0) {
        // Draw a straight line
        let mid = getPointBetween(point1: directLine.start, point2: directLine.end, distance: 0.5)
        return (directLine.start, mid, directLine.end, angle, angle - .pi, angle)
    }
    
    // How much are the two boxes overlapping?
    let overlapEffect = isColliding ? modulate(value: distanceBetween, from: (0, distance), to: (0, 1), clamp: true) : 0
    
    // How far away are the boxes?
    let distanceEffect = 1 - distanceBetween / distance
    
    // How much should the stretch impact the arc?
    let stretchEffect = modulate(value: distanceBetween, from: (stretchMin, stretchMax), to: (1, 0), clamp: true)
    
    // What should the curved line's arc be?
    var arc = bow + stretchEffect * stretch
    
    // How much should the angle's intermediacy (45degree-ness) affect the anglea
    let angleOffset = modulate(value: card.magnitudeSquared, from: (0, 1), to: (.pi * 0.125, 0), clamp: true)
    
    let distanceOffset = isColliding ? .pi * 0.5 * card : modulate(value: distanceEffect, from: (0.75, 1), to: (0, .pi * 0.5), clamp: true) * card
    
    let combinedOffset = distanceOffset + angleOffset * (isColliding ? 1 - overlapEffect : 1)
    
    let finalAngle0 = overlapEffect >= 0.5 ? angle + .pi * rotation : angle + max(Math.minimumAngle, combinedOffset) * rotation
    let startDelta = getDelta(angle: +(finalAngle0.truncatingRemainder(dividingBy: .pi * 2)))
    
    let startIntersection = getRayRoundedRectangleIntersection(ray: Ray(origin: rect1.center, direction: startDelta), rectangle: paddedRect1, radius: padStart).first ?? .zero
    let startSegment = getRectangleSegmentIntersectedByRay(ray: Ray(origin: paddedRect1.center, direction: startDelta), rect: paddedRect1) ?? .zero
    
    let startMidPoint = getPointBetween(point1: startSegment.start, point2: startSegment.end, distance: 0.5)
    let startPoint = getPointBetween(point1: startIntersection, point2: startMidPoint, distance: isColliding ? max(overlapEffect, 0.15) : 0.15)
    
    arc *= 1 + (max(-2, min(distanceEffect, 2)) * card - overlapEffect)/2
    
    if isColliding {
        arc = arc < 0 ? min(arc, -0.5) : max(arc, 0.5)
    }
    
    let endDelta: CGVector
    let endPoint: CGPoint
    
    if overlapEffect >= 0.5 {
        let rayAngle = getAngle(point1: paddedRect1.center, point2: startMidPoint)
        endDelta = getDelta(angle: rayAngle)
        endPoint = getRayRoundedRectangleIntersection(ray: Ray(origin: paddedRect2.center, direction: endDelta), rectangle: paddedRect2, radius: padEnd).first ?? .zero
    } else {
        let distanceOffset1 = modulate(value: distanceEffect, from: (0.75, 1), to: (0, 1), clamp: true)
        let overlapEffect1 = isColliding ? modulate(value: overlapEffect, from: (0, 1), to: (0, .pi/8), clamp: true) : 0
        let cardEffect1 = modulate(value: card * distanceOffset1, from: (0, 1), to: (0, .pi/16), clamp: true)
        let combinedOffset = distanceEffect * (.pi/12) + cardEffect1 + overlapEffect1 + (distanceOffset + angleOffset)/2
        var finalAngle1 = overlapEffect >= 0.5 ? angle + .pi * rotation : angle + .pi - max(combinedOffset, Math.minimumAngle) * rotation
        endDelta = getDelta(angle: +finalAngle1.truncatingRemainder(dividingBy: .pi*2))
        
        let endIntersection = getRayRoundedRectangleIntersection(ray: Ray(origin: paddedRect2.center, direction: endDelta), rectangle: paddedRect2, radius: padEnd).first ?? .zero
        let endSegment = getRectangleSegmentIntersectedByRay(ray: Ray(origin: paddedRect2.center, direction: endDelta), rect: paddedRect2) ?? .zero
        let endMidPoint = getPointBetween(point1: endSegment.start, point2: endSegment.end, distance: 0.5)
        endPoint = getPointBetween(point1: endIntersection, point2: endMidPoint, distance: 0.25 + overlapEffect * 0.25)
    }
    
    let midPoint = getPointBetween(point1: startPoint, point2: endPoint, distance: 0.5)
    let intersectionPoint = getPointBetween(point1: startPoint, point2: endPoint, distance: max(-1, min(1, 0.5 + arc)))
    
    let cornerIntersectionA = rotate(point: intersectionPoint, center: midPoint, angle: (Math.halfPi) * rotation)
    let cornerIntersectionB = rotate(point: intersectionPoint, center: midPoint, angle: (Math.halfPi) * -rotation)
    
    let cornerIntersection = isColliding && Segment(start: cornerIntersectionA, end: paddedRect2.center).length < Segment(start: cornerIntersectionB, end: paddedRect2.center).length ? cornerIntersectionB : cornerIntersectionA
    let startAngle = getAngle(point1: cornerIntersection, point2: startPoint)
    let endAngle = getAngle(point1: cornerIntersection, point2: endPoint)
    
    return (startPoint, cornerIntersection, endPoint, endAngle, startAngle, getAngle(point1: startPoint, point2: endPoint))
}

