//
//  File.swift
//  
//
//  Created by Purav Manot on 11/02/23.
//

import Foundation
import SwiftUI

public extension CGSize {
    static func + (left: Self, right: Self) -> Self {
        return Self.init(width:  left.width + right.width, height:  left.height + right.height)
    }
    
    static func - (left: Self, right: Self) -> Self {
        return Self.init(width:  left.width - right.width, height:  left.height - right.height)
    }
    
    static func / (left: Self, right: any BinaryInteger) -> Self {
        return Self.init(width:  left.width / CGFloat(right), height:  left.height / CGFloat(right))
    }
    
    func offset(_ axis: Axis, _ amount: CGFloat) -> Self {
        switch axis {
            case .horizontal:
                return Self.init(width:  self.width + amount, height:  self.height)
            case .vertical:
                return Self.init(width:  self.width, height:  self.height + amount)
        }
    }
    
    func offset(_ amount: CGSize) -> Self {
        Self.init(width: self.width + amount.width, height: self.height + amount.height)
    }
}
