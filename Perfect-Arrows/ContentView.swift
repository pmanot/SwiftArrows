//
//  ContentView.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    @State var point: CGPoint = CGPoint.zero
    @State var offset: CGSize = CGSize.zero
    var draggedPoint: CGPoint {
        CGPoint(x: point.x + offset.width, y: point.y + offset.height)
    }
    var body: some View {
        GeometryReader { screen in
            CurvedLine(CGPoint(x: screen.size.width/2, y: screen.size.height/2), draggedPoint, bow: 100)
                .stroke(lineWidth: 2)
                .animation(.default, value: draggedPoint)
                .overlay {
                    Circle()
                        .frame(width: 20, height: 20)
                        .position(draggedPoint)
                        .gesture(dragGesture)
                }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { drag in
                offset = drag.translation
            }
            .onEnded { drag in
                    point = drag.location
                    offset = CGSize.zero
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CurvedLine: Shape {
    var pStart: CGPoint
    var pEnd: CGPoint
    var curveOffset: CGFloat
    var midpoint: CGPoint {
        (pStart + pEnd)/2
    }
    
    // x2 + y2 = m2
    // y/x = p
    // y = px
    // x2 + p2x2 = m2
    // => x2 ( 1 + p2) = m2
    // => x = m2 / (1 + p2)
    // => y = px
    
    init(_ p1: CGPoint, _ p2: CGPoint, bow: CGFloat){
        self.pStart = p1
        self.pEnd = p2
        self.curveOffset = bow
    }
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            /* debugging
            p.move(to: pStart)
            p.addLine(to: pEnd)
            p.move(to: midpoint)
            p.addLine(to: control)
            */
            
            // draw the curve
            p.move(to: pStart)
            p.addQuadCurve(to: pEnd, control: CGPoint(from: midpoint, displacement: curveOffset, gradient: normal(pStart, pEnd)))
            
            // draw the arrow
        }
    }
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
