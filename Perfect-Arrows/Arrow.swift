//
//  Arrow.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 16/06/22.
//

import SwiftUI

struct Arrow: View {
    let startPoint: CGPoint = CGPoint.zero
    let endPoint: CGPoint = CGPoint.init(x: 300, y: 400)
    let startPadding: CGFloat = 50
    let endPadding: CGFloat = 10
    var body: some View {
        GeometryReader { screen in
            CurvedLine(startPoint, endPoint, bow: 5)
                .stroke(lineWidth: 2)
                .overlay {
                    Circle()
                        .frame(width: 20, height: 20)
                        .position(startPoint)
                }
        }
    }
    
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
    }
}


func getEdges(in frame: CGSize, position: CGPoint) -> [CGPoint] {
    let halfWidth = frame.width/2
    let halfHeight = frame.height/2
    let minX = position.x - halfWidth
    let maxX = position.x + halfWidth
    let minY = position.y - halfHeight
    let maxY = position.y + halfHeight
    return [
        CGPoint(x: minX, y: position.y),
        CGPoint(x: maxX, y: position.y),
        CGPoint(x: position.x, y: minY),
        CGPoint(x: position.x, y: maxY)
    ]
}

extension CGPoint {
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

func gradient(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    let change = (p1 - p2)
    return (change.y / change.x)
}

func normal(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    let change = (p1 - p2)
    return (-change.x / change.y)
}

func normal(gradient: CGFloat) -> CGFloat {
    return (-1 / gradient)
}
