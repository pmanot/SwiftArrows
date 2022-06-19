//
//  ContentView.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    @State var point: CGPoint = CGPoint.zero
    @State var offset: CGSize = CGSize.zero
    var draggedPoint: CGPoint {
        CGPoint(x: point.x + offset.width, y: point.y + offset.height)
    }
    var body: some View {
        GeometryReader { screen in
            CurvedLine(CGPoint(x: screen.size.width/2, y: screen.size.height/2), draggedPoint, bow: 100)
                .stroke(lineWidth: 2)
                .animation(.default, value: draggedPoint)
                .overlay {
                    Circle()
                        .frame(width: 20, height: 20)
                        .position(draggedPoint)
                        .gesture(dragGesture)
                }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { drag in
                offset = drag.translation
            }
            .onEnded { drag in
                    point = drag.location
                    offset = CGSize.zero
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
