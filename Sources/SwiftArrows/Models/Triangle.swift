//
//  Triangle.swift
//  Arrows
//
//  Created by Purav Manot on 31/01/23.
//

import Foundation
import SwiftUI

public struct Triangle: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
    
    public init() { }
}
