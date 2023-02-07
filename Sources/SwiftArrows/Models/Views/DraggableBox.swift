//
//  DraggableBox.swift
//  Arrows
//
//  Created by Purav Manot on 31/01/23.
//

import SwiftUI

public struct DraggableBox<Content: View>: View {
    //@Binding var location: CGPoint
    @Binding var frame: CGRect
    @State private var position: CGPoint
    @State private var offset: CGSize = .zero
    var content: () -> Content
    
    public init(frame: Binding<CGRect>, content: @escaping () -> Content) {
        self._frame = frame
        self.position = frame.wrappedValue.center
        self.content = content
    }
    
    public var body: some View {
        content()
            .frame(width: frame.width, height: frame.height)
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

public struct Draggable<Content: View>: View {
    //@Binding var location: CGPoint
    @Binding var position: CGPoint
    @State private var offset: CGSize = .zero
    var content: () -> Content
    
    public init(position: Binding<CGPoint>, content: @escaping () -> Content) {
        self._position = position
        self.content = content
    }
    
    public var body: some View {
        content()
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                       // withAnimation(.spring().speed(1.5)) {
                        offset = value.translation
                        self.position = position.offset(offset)
                       // }
                    }
                    .onEnded { value in
                        position = CGPoint(x: value.translation.width + position.x, y: value.translation.height + position.y)
                        offset = .zero
                        //location = position
                    }
            )
    }
}
