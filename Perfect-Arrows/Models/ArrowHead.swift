//
//  ArrowHead.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 20/06/22.
//

import Foundation
import SwiftUI

struct ArrowHead: Shape {
    func path(in rect: CGRect) -> Path {
        Path {
            p in
            p.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}
