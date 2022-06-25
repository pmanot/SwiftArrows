//
//  Functions.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 18/06/22.
//

import Foundation
import SwiftUI


// MARK: - Arrow function

// Point to point arrow
func getArrow(_ p1: CGPoint, _ p2: CGPoint, padding: Double = 25, bow: Double = 0.3) -> (CGPoint, CGPoint, CGPoint, Angle, Angle, Angle){
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

func modulate(_ value: Double, from: (Double, Double), to: (Double, Double), clamp: Bool = false) -> CGFloat {
    let result = to.0 + (value - from.0) / (from.1 - from.0) * (to.1 - to.0)
    
    if (clamp) {
        if (to.0 < to.1) {
            if (result < to.0) { return to.0 }
            if (result > to.1) { return to.1 }
        }
        else {
            if (result > to.0) { return to.0 }
            if (result < to.1) { return to.1 }
        }
    }
    
    return result
}

func rotatePoint(_ p1: CGPoint, around p2: CGPoint, angle: Angle) -> CGPoint {
    let change = p1 - p2
    
    let sin = sin(angle.radians),
        cos = cos(angle.radians)
    
    let x = change.x * cos - change.y * sin + p2.x,
        y = change.x * sin + change.y * cos + p2.y
    return CGPoint(x: x, y: y)
}

func getDistance(from p1: CGPoint, to p2: CGPoint) -> Double {
    let change = p2 - p1
    return hypot(change.y, change.x)
}

func getAngle(from p1: CGPoint, to p2: CGPoint) -> Angle {
    let change = p2 - p1
    
    return Angle(radians: atan2(change.y, change.x))
}

func projectPoint(from p1: CGPoint, angle: Angle, distance d: Double) -> CGPoint {
    let sin = sin(angle.radians),
        cos = cos(angle.radians)
    
    return CGPoint(x: p1.x + cos * d, y: p1.y + sin * d)
}

func getPointBetween(_ p1: CGPoint, _ p2: CGPoint, d: Double = 0.5) -> CGPoint {
    let change = p2 - p1
    
    return CGPoint(x: p1.x + change.x * d, y: p1.y + change.y * d)
}


func getSector(angle: Angle, sectors: Double = 8) -> Double {
    return floor(sectors * (0.5 + (angle.radians / (.pi * 2)).truncatingRemainder(dividingBy: sectors)))
}

func getAngliness(_ p1: CGPoint, _ p2: CGPoint) -> Double {
    let change = p2 - p1
    return abs(change.x / 2 / change.y / 2)
}

func doRectanglesCollide(r1: CGRect, r2: CGRect) -> Bool {
    return r1.intersects(r2)
}

func getSegmentCircleIntersections(origin c: CGPoint, radius r: Double, startPoint p1: CGPoint, change delta: CGPoint) -> [CGPoint]{
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
    return Angle(radians: angle.radians - .pi * 2 * floor(angle.radians / (.pi * 2)))
}

func getRaySegmentIntersection(rayOrigin origin: CGPoint, delta change: CGPoint, segmentStartPoint p1: CGPoint, segmentEndPoint p2: CGPoint) -> CGPoint? {
    let r: CGFloat, s: CGFloat, d: CGFloat;
    let (dx, dy) = (change.x, change.y)
    let (x1, y1) = (p2.x, p2.y)
    let (x0, y0) = (p1.x, p1.y)
    let (x, y) = (origin.x, origin.y)

      if (dy * (x1 - x0) != dx * (y1 - y0)) {
        d = dx * (y1 - y0) - dy * (x1 - x0);

        if (d != 0) {
          r = ((y - y0) * (x1 - x0) - (x - x0) * (y1 - y0)) / d;
          s = ((y - y0) * dx - (x - x0) * dy) / d;

          if (r >= 0 && s >= 0 && s <= 1) {
              return CGPoint(x: x + r * dx, y: y + r * dy);
          }
        }
      }
    
    return nil
}

func getDelta(angle: Angle) -> CGPoint {
    return CGPoint(x: cos(angle.radians), y: sin(angle.radians))
}

func getIntermediate(angle: Angle) -> Double {
    return abs(abs(angle.radians.truncatingRemainder(dividingBy: .pi / 2)) - (.pi / 4)) / (.pi / 4)
}

func getRectangleSegments(_ rect: CGRect) -> [(CGPoint, CGPoint)] {
    return [
        (CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY)),
        (CGPoint(x: rect.maxX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.maxY)),
        (CGPoint(x: rect.maxX, y: rect.maxY), CGPoint(x: rect.minX, y: rect.maxY)),
        (CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.minX, y: rect.minY))
    ]
}

func getRectangleSegmentIntersectedByRay(_ rect: CGRect, rayOrigin: CGPoint, delta change: CGPoint) -> (CGPoint, CGPoint) {
    let segments = getRectangleSegments(rect)
    for segment in segments {
        let intersectingPoint = getRaySegmentIntersection(rayOrigin: rayOrigin, delta: change, segmentStartPoint: segment.0, segmentEndPoint: segment.1)
        if intersectingPoint != nil {
            return segment
        }
    }
    
    return (CGPoint.zero, CGPoint.zero)
}

func getRayCircleIntersection(origin: CGPoint, radius: Double, startPoint: CGPoint, change: CGPoint) -> [CGPoint] {
    getSegmentCircleIntersections(origin: origin, radius: radius, startPoint: startPoint, change: change * 999999)
}

func getRayRoundedRectangleIntersection(rayOrigin origin: CGPoint, delta change: CGPoint, rectangleSize rect: CGRect, cornerRadius r: CGFloat) -> [CGPoint] {
    let x = rect.minX
    let y = rect.minY
    let w = rect.width
    let h = rect.height
    let mx = x + w,
        my = y + h,
        rx = x + r - 1,
        ry = y + r - 1,
        mrx = x + w - r + 1,
        mry = y + h - r + 1;
    let segments: [(CGPoint, CGPoint)] = [(CGPoint(x: x, y: mry), CGPoint(x: x, y: ry)), (CGPoint(x: rx, y: y), CGPoint(x: mrx, y: y)), (CGPoint(x: mx, y: ry), CGPoint(x: mx, y: mry)), (CGPoint(x: mrx, y: my), CGPoint(x: rx, y: my))];
    let corners: [(CGPoint, Angle, Angle)] = [(CGPoint(x: rx, y: ry), Angle(radians: .pi), Angle(radians: .pi) * 1.5), (CGPoint(x: mrx, y: ry), Angle(radians: .pi) * 1.5, Angle(radians: .pi) * 2), (CGPoint(x: mrx, y: mry), Angle(radians: 0), Angle(radians: .pi) * 0.5), (CGPoint(x: rx, y: mry), Angle(radians: .pi) * 0.5, Angle(radians: .pi))];
    
    var points: [CGPoint] = []
    for (i, segment) in segments.enumerated() {
        let p1 = segment.0,
            p2 = segment.1
        let cornerAngleTuple = corners[i]
        let cornerPoint = cornerAngleTuple.0
        let startAngle = cornerAngleTuple.1
        let endAngle = cornerAngleTuple.2
        
        let intersections = getRayCircleIntersection(origin: cornerPoint, radius: r, startPoint: origin, change: change)
        for intersectionPoint in intersections {
            let pointAngle = normalizeAngle(angle: getAngle(from: cornerPoint, to: intersectionPoint))
            if pointAngle > startAngle && pointAngle < endAngle {
                points.append(intersectionPoint)
            }
        }
        let segmentIntersection = getRaySegmentIntersection(rayOrigin: origin, delta: change, segmentStartPoint: p1, segmentEndPoint: p2)
        if segmentIntersection != nil {
            points.append(segmentIntersection!)
        }
    }
    return points
}

func getLineBetweenRoundedRectangles(rect1: CGRect, radius r1: Double, rect2: CGRect, radius r2: Double) -> (CGPoint, CGPoint) {
    let center1 = CGPoint(x: rect1.midX, y: rect1.midY)
    let center2 = CGPoint(x: rect2.midX, y: rect2.midY)
    
    let ref3 = getRayRoundedRectangleIntersection(rayOrigin: center1, delta: center2 - center1, rectangleSize: rect1, cornerRadius: r1)
    let ref4 = getRayRoundedRectangleIntersection(rayOrigin: center2, delta: center1 - center2, rectangleSize: rect2, cornerRadius: r2)
    return ((ref3 == [] ? center1 : ref3[0]), (ref4 == [] ? center2 : ref4[0]))
}


// MARK: - Kill me

// Box to box arrow (my version, get swifty)
func getBoxtoBoxArrow(rect1: CGRect, rect2: CGRect, padding: Double = 0, bow: Double = 0.3, allowStraight: Bool = true) -> (CGPoint, CGPoint, CGPoint, Angle, Angle, Angle) {
    let point1 = CGPoint(x: rect1.minX - padding, y: rect1.minY - padding),
        point2 = CGPoint(x: rect2.minX - padding, y: rect2.minY - padding),
        rectSize1 = CGSize(width: rect1.width + padding * 2, height: rect1.height + padding * 2),
        rectSize2 = CGSize(width: rect2.width + padding * 2, height: rect2.height + padding * 2),
        paddedRect1 = CGRect(origin: point1, size: rectSize1),
        paddedRect2 = CGRect(origin: point2, size: rectSize2),
        center1 = CGPoint(x: paddedRect1.midX, y: paddedRect1.midY),
        center2 = CGPoint(x: paddedRect2.midX, y: paddedRect2.midY)
    
    let angle = normalizeAngle(angle: getAngle(from: center1, to: center2))
    let distance = getDistance(from: center1, to: center2)
    
    if distance == 0 {
        let pStart = CGPoint(x: center1.x, y: point1.y)
        let pEnd = CGPoint(x: center2.x, y: point2.y)
        let control = getPointBetween(pStart, pEnd, d: 0.5)
        let angle = getAngle(from: pStart, to: pEnd)
        return (pStart, control, pEnd, angle, angle, angle)
    }
    
    let rotation = Double((getSector(angle: angle).truncatingRemainder(dividingBy: 2) == 0 ? -1 : 1) * 1)
    var card = getIntermediate(angle: angle)
    if card < 1 && card > 0.85 {
        card = 0.99
    }
    
    let isColliding = doRectanglesCollide(r1: paddedRect1, r2: paddedRect2)
    let line = getLineBetweenRoundedRectangles(rect1: paddedRect1, radius: padding, rect2: paddedRect2, radius: padding)
    let distanceBetween = getDistance(from: line.0, to: line.1)
    
    if (!isColliding && allowStraight && card.truncatingRemainder(dividingBy: 0.5) == 0) {
        let control = getPointBetween(line.0, line.1, d: 0.5)
        return (line.0, control, line.1, angle, Angle(radians: angle.radians - .pi), angle)
    }

    /* -------------- RETURN A CURVED ARROW ------------- */
    let overlapEffect = isColliding ? modulate(distanceBetween, from: (0, distance), to: (0, 1), clamp: true) : 0
    let distEffect = 1 - distanceBetween / distance
    
    var arc = bow
    
    let angleOffset = modulate(card * card, from: (0, 1), to: (.pi * 0.125, 0), clamp: true)
    let distOffset = isColliding ? .pi * 0.5 * card : modulate(distEffect, from: (0.75, 1), to: (0, .pi * 0.5), clamp: true) * card
    let combinedOffset = distOffset + angleOffset * (isColliding ? 1 - overlapEffect : 1)
    
    let finalRadians = (overlapEffect >= 0.5) ? (angle.radians + .pi * rotation) : (angle.radians + max(.pi / 24, combinedOffset) * rotation)
    
    let delta = getDelta(angle: Angle(radians: finalRadians.truncatingRemainder(dividingBy: .pi * 2)))
    let getRayRoundedRectangle = getRayRoundedRectangleIntersection(rayOrigin: center1, delta: delta, rectangleSize: paddedRect1, cornerRadius: padding)
    
    let tsPoint = getRayRoundedRectangle[0]
    
    let startSegment = getRectangleSegmentIntersectedByRay(paddedRect1, rayOrigin: center1, delta: delta)
    
    let getPointBetween3 = getPointBetween(startSegment.0, startSegment.1, d: 0.5)
    let pStart = getPointBetween(tsPoint, getPointBetween3, d: isColliding ? max(overlapEffect, 0.15) : 0.15) // sx, sy
    
    arc = arc * (1 + Double(max(-2, min(distEffect, 2)) * card - overlapEffect) / Double(2))

    if isColliding {
        arc = arc < 0 ? min(arc, -0.5) : max(arc, 0.5)
    }
    
    let pEnd: CGPoint
    
    if overlapEffect >= 0.5 {
        let rayAngle = getAngle(from: center1, to: getPointBetween3)
        let delta2 = getDelta(angle: rayAngle)
        let getRayRoundedRectangle3 = getRayRoundedRectangleIntersection(rayOrigin: center2, delta: delta2, rectangleSize: paddedRect2, cornerRadius: padding)
        pEnd = getRayRoundedRectangle3[0] // ex, ey
    } else {
        // var distOffset1 = modulate(distEffect, [0.75, 1], [0, 1], true);
        let distOffset1 = modulate(distEffect, from: (0.75, 1), to: (0, 1), clamp: true)
        
        // var overlapEffect1 = isColliding ? modulate(overlapEffect, [0, 1], [0, PI$1 / 8], true) : 0;
        let overlapEffect1 = isColliding ? modulate(overlapEffect, from: (0, 1), to: (0, .pi / 8), clamp: true) : 0
        
        // var cardEffect1 = modulate(card * distOffset1, [0, 1], [0, PI$1 / 16], true);
        let cardEffect1 = modulate(card * distOffset1, from: (0, 1), to: (0, .pi / 16), clamp: true)
        
        // var _combinedOffset = distEffect * (PI$1 / 12) + (cardEffect1 + overlapEffect1) + (distOffset + angleOffset) / 2;
        let combinedOffset = distEffect * (.pi / 12) + (cardEffect1 + overlapEffect1) + (distOffset + angleOffset) / 2
        
        // var finalAngle1 = overlapEffect >= 0.5 ? angle + PI$1 * rot : angle + PI$1 - Math.max(_combinedOffset, MIN_ANGLE) * rot; // Deltas of ending angle
        let finalRadians2 = overlapEffect >= 0.5 ? angle.radians + .pi * rotation : angle.radians + .pi - max(combinedOffset, .pi / 24) * rotation
        
        /*
         var _getDelta3 = getDelta(+(finalAngle1 % PI2).toPrecision(3)),
                 _dx = _getDelta3[0],
                 _dy = _getDelta3[1]; // Get ray intersection with ending rounded rectangle
         */
        let delta3 = getDelta(angle: Angle(radians: finalRadians2.truncatingRemainder(dividingBy: .pi/2))) // _dx, _dy
        
        /*
         var _getRayRoundedRectang5 = getRayRoundedRectangleIntersection(cx1, cy1, _dx, _dy, px1, py1, pw1, ph1, padEnd),
                _getRayRoundedRectang6 = _getRayRoundedRectang5[0],
                tex = _getRayRoundedRectang6[0],
                tey = _getRayRoundedRectang6[1]; // Get midpoint of ending intersected segment
         */
        let getRayRoundedRectangle5 = getRayRoundedRectangleIntersection(rayOrigin: center2, delta: delta3, rectangleSize: paddedRect2, cornerRadius: padding)
        let getRayRoundedRectangle6 = getRayRoundedRectangle5[0] // tex, tey
        
        /*
         var endSeg = getRectangleSegmentIntersectedByRay(px1, py1, pw1, ph1, cx1, cy1, _dx, _dy);
         if (!endSeg) throw Error;
             var sex0 = endSeg[0],
                 sey0 = endSeg[1],
                 sex1 = endSeg[2],
                 sey1 = endSeg[3];
         */
        let endSegment = getRectangleSegmentIntersectedByRay(paddedRect2, rayOrigin: center2, delta: delta3) // sex0, sey0, sex1, sey1
        
        /*
         var _getPointBetween5 = getPointBetween(sex0, sey0, sex1, sey1, 0.5),
                 empx = _getPointBetween5[0],
                 empy = _getPointBetween5[1];
         */
        let getPointBetween5 = getPointBetween(endSegment.0, endSegment.1, d: 0.5) // empx, empy
        
        /*
         var _getPointBetween6 = getPointBetween(tex, tey, empx, empy, 0.25 + overlapEffect * 0.25);

             ex = _getPointBetween6[0];
             ey = _getPointBetween6[1];
         */
        let getPointBetween6 = getPointBetween(getRayRoundedRectangle6, getPointBetween5, d: 0.25 + overlapEffect * 0.25) // ex, ey
        pEnd = getPointBetween6 // ex, ey
    }
    /*
     var _getPointBetween7 = getPointBetween(sx, sy, ex, ey, 0.5),
           mx1 = _getPointBetween7[0],
           my1 = _getPointBetween7[1];
     */
    let getPointBetween7 = getPointBetween(pStart, pEnd, d: 0.5) // mx1, my1
    
    /*
     var _getPointBetween8 = getPointBetween(sx, sy, ex, ey, Math.max(-1, Math.min(1, 0.5 + arc)) // Clamped to 2
       ),
           tix = _getPointBetween8[0],
           tiy = _getPointBetween8[1]; // Rotate them (these are our two potential corners)
     */
    let getPointBetween8 = getPointBetween(pStart, pEnd, d: max(-1, min(1, 0.5 + arc))) // tix, tiy
    
    /*
     var _rotatePoint = rotatePoint(tix, tiy, mx1, my1, PI$1 / 2 * rot),
           cixA = _rotatePoint[0],
           ciyA = _rotatePoint[1];
     */
    let rotatedPoint1 = rotatePoint(getPointBetween8, around: getPointBetween7, angle: Angle(radians: .pi / 2 * rotation)) // cixA, ciyA
    
    /*
     var _rotatePoint2 = rotatePoint(tix, tiy, mx1, my1, PI$1 / 2 * -rot),
           cixB = _rotatePoint2[0],
           ciyB = _rotatePoint2[1]; // If we're colliding, pick the furthest corner from the end point.
     */
    let rotatedPoint2 = rotatePoint(getPointBetween8, around: getPointBetween7, angle: Angle(radians: .pi / 2 * -rotation)) // cixB, ciyB
    
    /*
     var _ref = isColliding && getDistance(cixA, ciyA, cx1, cy1) < getDistance(cixB, ciyB, cx1, cy1) ? [cixB, ciyB] : [cixA, ciyA],
           cix = _ref[0],
           ciy = _ref[1]; // Start and end angles
     */
    let control = isColliding && getDistance(from: rotatedPoint1, to: center2) < getDistance(from: rotatedPoint2, to: center2) ? rotatedPoint2 : rotatedPoint1 // cix, ciy
    
    // var as = getAngle(cix, ciy, sx, sy);
    let aS = getAngle(from: control, to: pStart)
    
    // var ae = getAngle(cix, ciy, ex, ey);
    let aE = getAngle(from: control, to: pEnd)
    
    // return [sx, sy, cix, ciy, ex, ey, ae, as, getAngle(sx, sy, ex, ey)];
    return (pStart, control, pEnd, aE, aS, getAngle(from: pStart, to: pEnd))
}

// literally copy pasted the original code here and tweaked syntax to make it work
func getBoxToBoxArrow2(rect1: CGRect, rect2: CGRect, padding: Double = 0, bow: Double = 0.3, allowStraight: Bool = true, flip: Bool = false, stretch: Double = 0.25, stretchMin: Double = 50, stretchMax: Double = 420) -> (CGPoint, CGPoint, CGPoint, Angle, Angle, Angle) {
    let px0 = rect1.minX - padding,
        py0 = rect1.minY - padding,
        pw0 = rect1.width + padding * 2,
        ph0 = rect1.height + padding * 2,
        px1 = rect2.minX - padding,
        py1 = rect2.minY - padding,
        pw1 = rect2.width + padding * 2,
        ph1 = rect2.height + padding * 2,
        cx0 = rect1.minX + rect1.width / 2,
        cy0 = rect1.minY + rect1.height / 2,
        cx1 = rect2.minX + rect2.width / 2,
        cy1 = rect2.minY + rect2.height / 2; // Angle between centers
    
    let angle = normalizeAngle(angle: getAngle(from: CGPoint(cx0, cy0), to: CGPoint(cx1, cy1))); // Distance between centers

    let distance = getDistance(from: CGPoint(cx0, cy0), to: CGPoint(cx1, cy1)); // Perfect overlap, no arrow.

    if (distance == 0) {
        let _sx = cx0,
            _sy = py0;
        let _ex = cx1,
            _ey = py1;

        let control = getPointBetween(CGPoint(_sx, _sy), CGPoint(_ex, _ey), d: 0.5)
        let ca = getAngle(from: CGPoint(_sx, _sy), to: CGPoint(_ex, _ey));
        
        return (CGPoint(_sx, _sy), control, CGPoint(_ex, _ey), ca, ca, ca);
    } // Rotation of the arrow, clockwise or anticlockwise

    
    let rot = (getSector(angle: angle).truncatingRemainder(dividingBy: 2) == 0 ? -1 : 1) * (flip ? -1 : 1); // How cardinal is the angle? 0 = 45deg, 1 = 90deg

    var card = getIntermediate(angle: angle);
    if (card < 1 && card > 0.85) { card = 0.99 }; // Are the boxes colliding / overlapping?

    let isColliding = doRectanglesCollide(r1: CGRect(px0, py0, pw0, ph0), r2: CGRect(px1, py1, pw1, ph1)); // Direct line between boxes
    
    let _getLineBetweenRounde = getLineBetweenRoundedRectangles(rect1: CGRect(px0, py0, pw0, ph0), radius: padding, rect2: CGRect(px1, py1, pw1, ph1), radius: padding),
        dix0 = _getLineBetweenRounde.0.x,
        diy0 = _getLineBetweenRounde.0.y,
        dix1 = _getLineBetweenRounde.1.x,
        diy1 = _getLineBetweenRounde.1.y; // Length of the direct line between boxes


    let distanceBetween = getDistance(from: CGPoint(dix0, diy0), to: CGPoint(dix1, diy1));
      /* ------------- RETURN A STRAIGHT ARROW ------------ */
      // Should we just draw a straight line?

    if (!isColliding && allowStraight && card.truncatingRemainder(dividingBy: 0.5) == 0) {
        let _getPointBetween2 = getPointBetween(CGPoint(dix0, diy0), CGPoint(dix1, diy1), d: 0.5),
            mpdx = _getPointBetween2.x,
            mpdy = _getPointBetween2.y;

        return (CGPoint(dix0, diy0), CGPoint(mpdx, mpdy), CGPoint(dix1, diy1), angle, angle - .pi, angle);
    }
      /* -------------- RETURN A CURVED ARROW ------------- */
      // How much are the two boxes overlapping?


    let overlapEffect = isColliding ? modulate(distanceBetween, from: (0, distance), to: (0, 1), clamp: true) : 0; // How far away are the two boxes?

    let distEffect = 1 - distanceBetween / distance; // How much should the stretch impact the arc?

    let stretchEffect = modulate(distanceBetween, from: (stretchMin, stretchMax), to: (1, 0), clamp: true); // What should the curved line's arc be?

    var arc = bow + stretchEffect * stretch; // How much should the angle's intermediacy (45degree-ness) affect the angle?

    var angleOffset = modulate(card * card, from: (0, 1), to: (.pi * 0.125, 0), clamp: true); // a better curve here?
    let distOffset = isColliding ? .pi * 0.5 * card : modulate(distEffect, from: (0.75, 1), to: (0, .pi * 0.5), clamp: true) * card; // a better curve here?
      let combinedOffset = distOffset + angleOffset * (isColliding ? 1 - overlapEffect : 1);
      /* ----------------- STARTING POINT ----------------- */
      // Angle of the first box

    let finalAngle0 = overlapEffect >= 0.5 ? (angle + .pi * Double(rot)) : (angle + max(.pi / 24, combinedOffset) * Double(rot)); // Deltas of starting angle

    let _getDelta = getDelta(angle: Angle(radians: finalAngle0.radians.truncatingRemainder(dividingBy: (.pi * 2)))),
        dx0 = _getDelta.x,
        dy0 = _getDelta.y; // Get ray intersection with rounded rectangle

    let _getRayRoundedRectang = getRayRoundedRectangleIntersection(rayOrigin: CGPoint(cx0, cy0), delta: CGPoint(dx0, dy0), rectangleSize: CGRect(px0, py0, pw0, ph0), cornerRadius: padding),
        _getRayRoundedRectang2 = _getRayRoundedRectang[0],
        tsx = _getRayRoundedRectang2.x,
        tsy = _getRayRoundedRectang2.y; // Get midpoint of startingintersected segment

    let startSeg = getRectangleSegmentIntersectedByRay(CGRect(px0, py0, pw0, ph0), rayOrigin: CGPoint(cx0, cy0), delta: CGPoint(dx0, dy0));
    
    let ssx0 = startSeg.0.x,
        ssy0 = startSeg.0.y,
        ssx1 = startSeg.1.x,
        ssy1 = startSeg.1.y;

    let _getPointBetween3 = getPointBetween(CGPoint(ssx0, ssy0), CGPoint(ssx1, ssy1), d: 0.5),
        smpx = _getPointBetween3.x,
        smpy = _getPointBetween3.y;

    let _getPointBetween4 = getPointBetween(CGPoint(tsx, tsy), CGPoint(smpx, smpy), d: isColliding ? max(overlapEffect, 0.15) : 0.15),
        sx = _getPointBetween4.x,
        sy = _getPointBetween4.y;
    
    arc = arc * (1 + Double(max(-2, min(distEffect, 2)) * card - overlapEffect) / 2);

    if (isColliding) {
        arc = arc < 0 ? min(arc, -0.5) : max(arc, 0.5);
    }
      /* ------------------ ENDING POINT ------------------ */
    
    var ex: Double = 0
    var ey: Double = 0
    
    if (overlapEffect >= 0.5) {
        // If overlapping, use the same angle as the start
        let rayAngle = getAngle(from: CGPoint(cx0, cy0), to: CGPoint(smpx, smpy));

        let _getDelta2 = getDelta(angle: rayAngle),
            dx1 = _getDelta2.x,
            dy1 = _getDelta2.y;

        let _getRayRoundedRectang3 = getRayRoundedRectangleIntersection(rayOrigin: CGPoint(cx1, cy1), delta: CGPoint(dx1, dy1), rectangleSize: CGRect(px1, py1, pw1, ph1), cornerRadius: padding);

        let _getRayRoundedRectang4 = _getRayRoundedRectang3[0],
            ex = _getRayRoundedRectang4.x,
            ey = _getRayRoundedRectang4.y;
    } else {
        // Calculate an angle based on distance, overlap and intermediacy
          let distOffset1 = modulate(distEffect, from: (0.75, 1), to: (0, 1), clamp: true);
          let overlapEffect1 = isColliding ? modulate(overlapEffect, from: (0, 1), to: (0, .pi / 8), clamp: true) : 0;
          let cardEffect1 = modulate(card * distOffset1, from: (0, 1), to: (0, .pi / 16), clamp: true);

          let _combinedOffset = distEffect * (.pi / 12) + (cardEffect1 + overlapEffect1) + (distOffset + angleOffset) / 2;

          let finalAngle1 = overlapEffect >= 0.5 ? (angle + .pi * Double(rot)) : (angle + .pi - max(_combinedOffset, .pi / 24) * Double(rot)); // Deltas of ending angle

          let _getDelta3 = getDelta(angle: Angle(radians: finalAngle1.radians.truncatingRemainder(dividingBy: (.pi * 2)))),
              _dx = _getDelta3.x,
              _dy = _getDelta3.y; // Get ray intersection with ending rounded rectangle


          let _getRayRoundedRectang5 = getRayRoundedRectangleIntersection(rayOrigin: CGPoint(cx1, cy1), delta: CGPoint(_dx, _dy), rectangleSize: CGRect(px1, py1, pw1, ph1), cornerRadius: padding),
            _getRayRoundedRectang6 = _getRayRoundedRectang5[0],
              tex = _getRayRoundedRectang6.x,
              tey = _getRayRoundedRectang6.y; // Get midpoint of ending intersected segment


          let endSeg = getRectangleSegmentIntersectedByRay(CGRect(px1, py1, pw1, ph1), rayOrigin: CGPoint(cx1, cy1), delta: CGPoint(_dx, _dy));
          let sex0 = endSeg.0.x,
              sey0 = endSeg.0.y,
              sex1 = endSeg.1.x,
              sey1 = endSeg.1.y;

          let _getPointBetween5 = getPointBetween(CGPoint(sex0, sey0), CGPoint(sex1, sey1), d: 0.5),
            empx = _getPointBetween5.x,
            empy = _getPointBetween5.y;

          let _getPointBetween6 = getPointBetween(CGPoint(tex, tey), CGPoint(empx, empy), d: 0.25 + overlapEffect * 0.25);

          ex = _getPointBetween6.x;
          ey = _getPointBetween6.y;
      }
      /* ------------------- DRAW ARROWS ------------------ */
      // Get midpoints.


    let _getPointBetween7 = getPointBetween(CGPoint(sx, sy), CGPoint(ex, ey), d: 0.5),
          mx1 = _getPointBetween7.x,
          my1 = _getPointBetween7.y;

    let _getPointBetween8 = getPointBetween(CGPoint(sx, sy), CGPoint(ex, ey), d: max(-1, min(1, 0.5 + arc)) // Clamped to 2
      ),
          tix = _getPointBetween8.x,
          tiy = _getPointBetween8.y; // Rotate them (these are our two potential corners)


    let _rotatePoint = rotatePoint(CGPoint(tix, tiy), around: CGPoint(mx1, my1), angle: Angle(radians: .pi / 2 * Double(rot))),
        cixA = _rotatePoint.x,
        ciyA = _rotatePoint.y;

    let _rotatePoint2 = rotatePoint(CGPoint(tix, tiy), around: CGPoint(mx1, my1), angle: Angle(radians: .pi / 2 * Double(-rot))),
        cixB = _rotatePoint2.x,
        ciyB = _rotatePoint2.y; // If we're colliding, pick the furthest corner from the end point.


    let _ref = ( isColliding && getDistance(from: CGPoint(cixA, ciyA), to: CGPoint(cx1, cy1)) < getDistance(from: CGPoint(cixB, ciyB), to: CGPoint(cx1, cy1)) ? CGPoint(cixB, ciyB) : CGPoint(cixA, ciyA) ),
        cix = _ref.x,
        ciy = _ref.y; // Start and end angles


    let aStart = getAngle(from: CGPoint(cix, ciy), to: CGPoint(sx, sy));
    let aEnd = getAngle(from: CGPoint(cix, ciy), to: CGPoint(ex, ey));
    let aControl = getAngle(from: CGPoint(sx, sy), to: CGPoint(ex, ey));
    return (CGPoint(sx, sy), CGPoint(cix, ciy), CGPoint(ex, ey), aEnd, aStart, aControl);
}


// MARK: - Links
//
// Original File: https://github.com/steveruizok/perfect-arrows/blob/a7708cec769e03402410695f4be44037e38b3100/src/lib/utils.ts





