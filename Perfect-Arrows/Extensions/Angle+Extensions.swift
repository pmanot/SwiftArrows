//
//  Angle+Extensions.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 25/06/22.
//

import Foundation
import SwiftUI

extension Angle {
    static func - (left: Angle, right: Double) -> Angle {
        return Angle(radians: left.radians - right)
    }
    
    static func - (left: Double, right: Angle) -> Angle {
        return Angle(radians: right.radians - left)
    }
    
    static func + (left: Angle, right: Double) -> Angle {
        return Angle(radians: left.radians + right)
    }
    
    static func + (left: Double, right: Angle) -> Angle {
        return Angle(radians: right.radians + left)
    }
    
    static func * (left: Angle, right: Double) -> Angle {
        return Angle(radians: left.radians * right)
    }
    
    static func * (left: Double, right: Angle) -> Angle {
        return Angle(radians: right.radians * left)
    }
    
    static func / (left: Angle, right: Double) -> Angle {
        return Angle(radians: left.radians / right)
    }
    
    static func / (left: Double, right: Angle) -> Angle {
        return Angle(radians: right.radians / left)
    }
    
}
