//
//  TickView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 18/06/2026.
//

import SwiftUI

struct TickView: View {

    let color: Color

    let tickWidth: CGFloat

    let tickHeight: CGFloat

    init(color: Color, tickWidth: CGFloat, tickHeight: CGFloat) {

        self.color = color
        self.tickWidth = tickWidth
        self.tickHeight = tickHeight
    }

    var body: some View {

        Rectangle()
            .fill(color)
            .frame(width: tickWidth, height: tickHeight)
    }
}

#Preview {
    TickView(color: .black, tickWidth: 1.5, tickHeight: 50.0)
}
