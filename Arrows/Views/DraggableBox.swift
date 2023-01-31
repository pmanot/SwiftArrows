//
//  DraggableBox.swift
//  Arrows
//
//  Created by Purav Manot on 31/01/23.
//

import SwiftUI

struct DraggableBox<Content: View>: View {
    //@Binding var location: CGPoint
    @Binding var frame: CGRect
    @State private var position: CGPoint
    @State private var offset: CGSize = .zero
    var content: () -> Content
    
    init(frame: Binding<CGRect>, content: @escaping () -> Content) {
        self._frame = frame
        self.position = frame.wrappedValue.center
        self.content = content
    }
    
    var body: some View {
        content()
            .frame(width: frame.width, height: frame.height)
            .contentShape(.interaction, Rectangle())
            .position(frame.center)
            .gesture(
                DragGesture()
                    .onChanged { value in
                       // withAnimation(.spring().speed(1.5)) {
                        offset = value.translation
                        frame = CGRect(x: position.x + offset.width - frame.width/2, y: position.y + offset.height - frame.height/2, width: frame.width, height: frame.height)
                       // }
                    }
                    .onEnded { value in
                        position = CGPoint(x: value.translation.width + position.x, y: value.translation.height + position.y)
                        offset = .zero
                        frame = CGRect(x: position.x - frame.width/2, y: position.y - frame.height/2, width: frame.width, height: frame.height)
                        //location = position
                    }
            )
    }
}

/*
struct DraggableBox_Previews: PreviewProvider {
    static var previews: some View {
        DraggableBox(frame: .constant(CGRect(x: 0, y: 0, width: 100, height: 100)) {
            Circle()
        }
    }
}
*/
