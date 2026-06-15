//
//  ContentView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

@Observable
class HydrationModel {

    var dough: Int = 500

    var water: Int = 300

    var hydration: Double {
        get {
            if water <= 0 {
                return 0
            } else {
                return Double(water) / Double(dough)
            }
        } set {
            if newValue <= 0 {
                water = 0
            } else {
                water = Int(Double(dough) * newValue)
            }
        }
    }

    var hydrationPercent: Int {
        get { min(Int(hydration * 100.0), 100) }
        set {
            hydration = Double(newValue) / 100.0
        }
    }
}

struct ContentView: View {

    @State private var hapticGenerator: UISelectionFeedbackGenerator? = nil

    @State var viewModel = HydrationModel()

    var body: some View {
        VStack(spacing: 40) {

            Text("Hydration = Water / Dough")

            LinkedScaleView(variable: $viewModel.hydrationPercent, title: "Hydration", maxValue: 100, stepValue: 1, unit: "%", itemWidth: 2.0, itemSpacing: 15.0, hapticGenerator: $hapticGenerator)

            LinkedScaleView(variable: $viewModel.dough, title: "Dough", maxValue: 1000, stepValue: 1, unit: "g", itemWidth: 1.5, itemSpacing: 10.0, hapticGenerator: $hapticGenerator)

            LinkedScaleView(variable: $viewModel.water, title: "Water", maxValue: 1000, stepValue: 1, unit: "g", itemWidth: 1.5, itemSpacing: 10.0, hapticGenerator: $hapticGenerator)
        }
        .onAppear {
            if hapticGenerator == nil {
                hapticGenerator = UISelectionFeedbackGenerator()
            }


        }
        .padding()
    }
}

#Preview {
    ContentView()
}
