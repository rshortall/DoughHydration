//
//  ContentView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct ContentView: View {

    @State private var hapticGenerator: UISelectionFeedbackGenerator? = nil

    @State var viewModel = HydrationModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                presetButtons
                    .padding(.bottom, 20)

                VStack(spacing: 40) {

                    LinkedScaleView(variable: $viewModel.hydrationPercent, title: "Hydration", maxValue: 100, stepValue: 1, unit: "%", itemWidth: 2.0, itemSpacing: 12.0, secondaryUnit: "", secondaryValue: "", hapticGenerator: $hapticGenerator)

                    LinkedScaleView(variable: $viewModel.dough, title: "Dough", maxValue: 1000, stepValue: 1, unit: Constants.doughPrimaryUnit, itemWidth: 1.5, itemSpacing: 10.0, secondaryUnit: Constants.doughSecondaryUnit, secondaryValue: viewModel.doughSecondary, hapticGenerator: $hapticGenerator)

                    LinkedScaleView(variable: $viewModel.water, title: "Water", maxValue: 1000, stepValue: 1, unit: Constants.waterPrimaryUnit, itemWidth: 1.5, itemSpacing: 10.0, secondaryUnit: Constants.waterSecondaryUnit, secondaryValue: viewModel.waterSecondary, hapticGenerator: $hapticGenerator)
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
                    Button(action: {}) { Image(systemName: "gearshape") }
                }
            }
            .navigationTitle("Hydration = Dough / Water")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var presetButtons: some View {

        ScrollView(.horizontal, showsIndicators: false) {
            HStack {

                Button {

                } label: {
                    Text("White")
                }
                .buttonStyle(.bordered)

                Button {

                } label: {
                    Text("Pizza")
                }
                .buttonStyle(.bordered)

                Button {

                } label: {
                    Text("Foccacia")
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            .contentMargins(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
}
