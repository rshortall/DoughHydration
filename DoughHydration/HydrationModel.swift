//
//  HydrationModel.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 16/06/2026.
//

import SwiftUI

@Observable
class HydrationModel {

    var flour: Int = 500

    var water: Int = 300

    var hydration: Double {
        get {
            if water <= 0 {
                return 0
            } else {
                return Double(water) / Double(flour)
            }
        } set {
            if newValue <= 0 {
                water = 0
            } else {
                water = Int(Double(flour) * newValue)
            }
        }
    }

    var hydrationPercent: Int {
        get { min(Int(hydration * 100.0), 100) }
        set {
            hydration = Double(newValue) / 100.0
        }
    }

    var doughSecondary: String {

        // grams to cups
        String(format: "%.1f", (Double(flour) * 0.8) / 100.0)
    }

    var waterSecondary: String {

        // mls to fluid ounces
        String(format: "%.1f", Double(water) * 0.033)
    }

    func setMeasurements(from preset: Preset) {
        flour = preset.flour
        water = preset.water
    }
}
