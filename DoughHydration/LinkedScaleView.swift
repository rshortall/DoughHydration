//
//  LinkedScaleView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct LinkedScaleView: View {

    @Binding var variable: Double
    @Binding var formattedVariable: String

    let maxValue: Double
    let stepValue: Double

    var onNewValue: () -> Void

    var body: some View {

        HStack(spacing: 40) {
            Text(formattedVariable)
            Slider(value: $variable, in: 0...maxValue, step: stepValue)
        }
        .onChange(of: variable) {
            onNewValue()
        }
    }
}

#Preview {
    @Previewable @State var value: Double = 1.0
    @Previewable @State var formattedValue: String = "Value: 1.0"
    LinkedScaleView(variable: $value, formattedVariable: $formattedValue, maxValue: 100, stepValue: 1.0) {
        formattedValue = String("Value: \(value)")
        print("New " + formattedValue)
    }
}
