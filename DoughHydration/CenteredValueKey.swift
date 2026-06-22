//
//  CenteredValueKey.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct CenteredItem: Equatable {
    var value: Int
    var distance: CGFloat
}

struct CenteredValueKey: PreferenceKey {
    static var defaultValue = CenteredItem(value: 0, distance: .infinity)

    static func reduce(value: inout CenteredItem, nextValue: () -> CenteredItem) {
        let next = nextValue()
        if next.distance < value.distance {
            value = next
        }
    }
}
