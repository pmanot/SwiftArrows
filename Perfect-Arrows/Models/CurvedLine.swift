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
    var control: CGPoint
    
    init(_ p1: CGPoint, _ p2: CGPoint, control: CGPoint){
        self.pStart = p1
        self.pEnd = p2
        self.control = control
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { p in
            /* debugging
            p.move(to: pStart)
            p.addLine(to: pEnd)
            p.move(to: midpoint)
            p.addLine(to: control)
            */
            
            // draw the curve
            p.move(to: pStart)
            p.addQuadCurve(to: pEnd, control: control)
            
            // draw the arrow
        }
    }
}



