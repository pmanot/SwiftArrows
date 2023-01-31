//
//  IntersectionTest.swift
//  Arrows
//
//  Created by Purav Manot on 30/01/23.
//

import SwiftUI

struct IntersectionTest: View {
    @State private var position: CGPoint = .zero
    @State private var linePosition: CGPoint = .zero
    var ray: Ray {
        Ray(origin: linePosition, direction: CGVector(dx: 1, dy: 2))
    }
    private var intersectionPoints: [CGPoint] {
        getRayRoundedRectangleIntersection(ray: ray, rectangle: CGRect(origin: position, size: CGSize(width: 200, height: 200)), radius: 20)
    }
    
    var body: some View {
        GeometryReader { proxy in
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 200, height: 200)
                .position(position + CGPoint(x: 100, y: 100))
            
            Circle()
                .frame(width: 10, height: 10)
                .position(CGPoint(x: 200, y: 400))
            
            Circle()
                .frame(width: 10, height: 10)
                .position(CGPoint(x: 400, y: 400))
            
            Circle()
                .frame(width: 10, height: 10)
                .position(linePosition)
            
            
            ForEach(intersectionPoints, id: \.id) { point in
                Circle()
                    .foregroundColor(Color.red)
                    .frame(width: 10, height: 10)
                    .position(point)
            }
        }
    }
}

struct IntersectionTest_Previews: PreviewProvider {
    static var previews: some View {
        IntersectionTest()
    }
}
