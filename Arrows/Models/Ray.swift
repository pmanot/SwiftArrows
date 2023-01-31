//
//  Ray.swift
//  Arrows
//
//  Created by Purav Manot on 28/01/23.
//

import Foundation
import SwiftUI

struct Ray: Hashable {
    var origin: CGPoint
    var direction: CGVector
    
    var dx: CGFloat { direction.dx }
    var dy: CGFloat { direction.dy }
}
