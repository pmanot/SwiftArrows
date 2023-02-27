//
//  CurvedLine.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 18/06/22.
//

import Foundation
import SwiftUI

public struct CurvedLine: Shape {
    var start: CGPoint
    var end: CGPoint
    var control: CGPoint
    
    public init(from start: CGPoint, to end: CGPoint, control: CGPoint){
        self.start = start
        self.end = end
        self.control = control
    }
    
    public func path(in rect: CGRect) -> Path {
        return Path { p in
            
            // draw the curve
            p.move(to: start)
            p.addQuadCurve(to: end, control: control)
            p.move(to: start)
        }
    }
}
