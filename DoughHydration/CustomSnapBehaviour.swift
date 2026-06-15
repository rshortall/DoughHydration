//
//  CustomSnapBehaviour.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct CustomSnapBehaviour: ScrollTargetBehavior {
    let itemWidth: CGFloat
    let itemSpacing: CGFloat

    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {

        let itemStep = itemWidth + itemSpacing
        let index = (target.rect.minX / itemStep).rounded()
        let snappedX = index * itemStep
        
        target.rect.origin.x = snappedX
    }
}
