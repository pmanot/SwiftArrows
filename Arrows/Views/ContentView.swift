//
//  ContentView.swift
//  Arrows
//
//  Created by Purav Manot on 26/01/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rect1 = CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100))
    @State private var rect2 = CGRect(origin: CGPoint(x: 200, y: 200), size: CGSize(width: 150, height: 100))
    private var line: (CGPoint, CGPoint, CGPoint, CGFloat, CGFloat, CGFloat) {
        getBoxToBoxArrow(from: rect1, to: rect2, options: ArrowOptions(padEnd: 20, straights: true))
    }
    
    var body: some View {
        GeometryReader { proxy in
            DraggableBox(frame: $rect1) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.blue)
            }
            
            DraggableBox(frame: $rect2) {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.mint)
            }
            
            Circle()
                .foregroundStyle(.primary)
                .backgroundStyle(.ultraThinMaterial)
                .frame(width: 10, height: 10)
                .position(line.0)
            
            CurvedLine(from: line.0, to: line.2, control: line.1)
                .stroke(lineWidth: 5)
                .foregroundStyle(.primary)
            
            Triangle()
                .foregroundStyle(.primary)
                .frame(width: 20, height: 20)
                .rotationEffect(Angle(radians: line.3 + Math.halfPi))
                .position(x: line.2.x, y: line.2.y)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

