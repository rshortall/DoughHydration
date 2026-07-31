//
//  ContentView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct ContentView: View {

    @State private var tooglePresets = false
    @State private var toggleSettings = false
    @State private var hapticGenerator: UISelectionFeedbackGenerator? = nil

    @State var viewModel = HydrationModel()

    @State private var presets: [Preset] = []

    @AppStorage("showPresets") var showPresets: Bool = true
    @AppStorage("showImperial") var showImperial: Bool = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                if showPresets {
                    presetButtons
                        .padding(.bottom, 20)
                }

                VStack(spacing: 40) {

                    LinkedScaleView(variable: $viewModel.flour, title: Constants.flour, maxValue: 1000, stepValue: 1, unit: Constants.doughPrimaryUnit, itemWidth: 1.5, itemSpacing: 10.0, secondaryUnit: showImperial ? Constants.doughSecondaryUnit : "", secondaryValue: viewModel.doughSecondary, hapticGenerator: $hapticGenerator)

                    LinkedScaleView(variable: $viewModel.water, title: Constants.water, maxValue: 1000, stepValue: 1, unit: Constants.waterPrimaryUnit, itemWidth: 1.5, itemSpacing: 10.0, secondaryUnit: showImperial ? Constants.waterSecondaryUnit : "", secondaryValue: viewModel.waterSecondary, hapticGenerator: $hapticGenerator)

                    LinkedScaleView(variable: $viewModel.hydrationPercent, title: Constants.hydration, maxValue: 100, stepValue: 1, unit: "%", itemWidth: 2.0, itemSpacing: 12.0, secondaryUnit: "", secondaryValue: "", fillColor: Color.yellow.opacity(0.2), hapticGenerator: $hapticGenerator)
                }
            }
            .onAppear {
                if hapticGenerator == nil {
                    hapticGenerator = UISelectionFeedbackGenerator()
                }
            }
            .padding(.vertical)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        tooglePresets.toggle()
                    } label: {
                        Image(systemName: "checklist")
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        toggleSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $tooglePresets) {
                PresetPickerView(presets: presets) { updatedSelection in
                    saveSelection(updatedSelection)
                }
            }
            .sheet(isPresented: $toggleSettings) {
                SettingsView()
            }
            .navigationTitle(Constants.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {

            loadPresets()
        }
    }

    private func loadPresets() {

        if let value = UserDefaults.standard.object(forKey: "presets") as? Data {

            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Preset].self, from: value) {
                presets = decoded
            }

        } else {
            createPresets()
        }
    }

    private func createPresets() {
        let encoder = JSONEncoder()
        presets = [
            Preset(title: "Sandwich Bread", flour: 600, water: 360, isActive: true),
            Preset(title: "Baguette", flour: 500, water: 370, isActive: true),
            Preset(title: "Pizza", flour: 500, water: 325, isActive: true),
            Preset(title: "Bagels", flour: 550, water: 308, isActive: true),
            Preset(title: "Focaccia", flour: 550, water: 412, isActive: true)
        ]
        let encodedData = try? encoder.encode(presets)

        UserDefaults.standard.set(encodedData, forKey: "presets")
    }

    private var presetButtons: some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(presets.filter { $0.isActive}) { preset in
                    Button {
                        viewModel.setMeasurements(from: preset)
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Text(preset.title)
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .foregroundStyle(.white)
                    .background(.secondary)
                    .clipShape(.capsule)
                }
            }
            .padding(.horizontal)
            .contentMargins(.horizontal, 20)
        }
    }

    private func saveSelection(_ updatedSelection: [Preset]) {

        presets = updatedSelection

        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(presets)

        UserDefaults.standard.set(encodedData, forKey: "presets")
    }
}

#Preview {
    ContentView()
}
