//
//  CurvedLine.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 18/06/22.
//

import Foundation
import SwiftUI

struct CurvedLine: Shape {
    var pStart: CGPoint
    var pEnd: CGPoint
    var curveOffset: CGFloat
    
    init(_ p1: CGPoint, _ p2: CGPoint, bow: CGFloat){
        self.pStart = p1
        self.pEnd = p2
        self.curveOffset = bow
    }
    
    func path(in rect: CGRect) -> Path {
        let arrowData = getArrow(pStart, pEnd)
        return Path { p in
            /* debugging
            p.move(to: pStart)
            p.addLine(to: pEnd)
            p.move(to: midpoint)
            p.addLine(to: control)
            */
            
            // draw the curve
            p.move(to: arrowData.0)
            p.addQuadCurve(to: arrowData.2, control: arrowData.1)
            // draw the arrow
        }
    }
}