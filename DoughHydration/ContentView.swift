//
//  ContentView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct ContentView: View {

    @State var hydrationPercent: Double = 0.0
    @State var doughAmount: Double = 0.0
    @State var waterAmount: Double = 0.0

    @State var formattedWaterAmount: String = ""
    @State var formattedDoughAmount: String = ""
    @State var formattedHydrationAmount: String = ""

    var body: some View {
        VStack(spacing: 40) {

            Text("Hydration = Water / Dough")

            LinkedScaleView(variable: $hydrationPercent, formattedVariable: $formattedHydrationAmount, maxValue: 1.0, stepValue: 0.01) {
                updateWater()
            }
            .onChange(of: hydrationPercent) {
                formattedHydrationAmount = String(format: "Hydration: %.0f", min(hydrationPercent * 100.0, 100.0))
            }

            LinkedScaleView(variable: $doughAmount, formattedVariable: $formattedDoughAmount, maxValue: 1000.0, stepValue: 1.0) {
                updateHydration()
            }
            .onChange(of: doughAmount) {
                formattedDoughAmount = String(format: "Dough: %.0f", doughAmount)
            }

            LinkedScaleView(variable: $waterAmount, formattedVariable: $formattedWaterAmount, maxValue: 1000.0, stepValue: 1.0) {
                updateHydration()
            }
            .onChange(of: waterAmount) {
                formattedWaterAmount = String(format: "Water: %.0f", waterAmount)
            }
        }
        .padding()
        .onAppear {

            doughAmount = 500.0
            waterAmount = 300.0

            updateHydration()
        }
    }

    private func updateHydration() {

        guard doughAmount > 0 else {
            hydrationPercent = 0
            return
        }

        hydrationPercent = waterAmount / doughAmount

        //print("Updatding hydration: \(hydrationPercent) = \(waterAmount) / \(doughAmount)")
    }

    private func updateWater() {

        guard hydrationPercent > 0 else {
            waterAmount = 0
            return
        }

        waterAmount = doughAmount * hydrationPercent
    }
}

#Preview {
    ContentView()
}
