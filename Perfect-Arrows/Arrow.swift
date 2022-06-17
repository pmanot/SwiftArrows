//
//  Arrow.swift
//  Perfect-Arrows
//
//  Created by Purav Manot on 16/06/22.
//

import SwiftUI

struct Arrow: View {
    var body: some View {
        GeometryReader { screen in
            ZStack {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .position(x: screen.size.width/2 + 200, y: screen.size.height/2)
                Rectangle()
                    .frame(width: 100, height: 100)
                    .position(x: screen.size.width/2, y: screen.size.height/2)
            }
        }
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
    }
}
