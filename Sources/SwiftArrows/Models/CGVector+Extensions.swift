//
//  CGVector+Extensions.swift
//  Arrows
//
//  Created by Purav Manot on 31/01/23.
//

import Foundation

extension CGVector: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.dx)
        hasher.combine(self.dy)
    }
}
