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
    @State var startPoint: CGPoint = CGPoint(x: 20, y: 50)
    var draggedPoint: CGPoint {
        CGPoint(x: point.x + offset.width, y: point.y + offset.height)
    }
    var rect1: CGRect { CGRect(origin: draggedPoint, size: CGSize(width: 100, height: 100)) }
    var rect2: CGRect { CGRect(origin: startPoint, size: CGSize(width: 100, height: 100)) }
    var arrowData: (CGPoint, CGPoint, CGPoint, Angle, Angle, Angle) { getBoxtoBoxArrow(rect1: rect1, rect2: rect2, padding: 0, allowStraight: true) }
    var body: some View {
        GeometryReader { screen in
            ZStack {
                CurvedLine(arrowData.0, arrowData.2, control: arrowData.1)
                    .stroke(lineWidth: 2)
                    .animation(.default, value: draggedPoint)
                    .overlay {
                        CGRectangle(rect1)
                            .gesture(dragGesture)
                        CGRectangle(rect2)
                    }
                ArrowHead()
                    .rotationEffect(arrowData.3)
                    .frame(width: 20, height: 20)
                    .position(arrowData.2)
            }
            .onAppear {
                startPoint = CGPoint(x: screen.size.width / 2, y: screen.size.height / 2)
            }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { drag in
                offset = drag.translation
            }
            .onEnded { drag in
                point = point + CGPoint(x: drag.translation.width, y: drag.translation.height)
                    offset = CGSize.zero
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
