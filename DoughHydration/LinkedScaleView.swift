//
//  LinkedScaleView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 05/06/2026.
//

import SwiftUI

struct LinkedScaleView: View {

    @Binding var variable: Int

    let title: String
    let maxValue: Int
    let stepValue: Int
    let unit: String
    let itemWidth: CGFloat
    let itemSpacing: CGFloat

    let initialValue = 0.0

    let secondaryUnit: String
    let secondaryValue: String

    let fillColor: Color

    @State private var isUserScrolling = false
    @State private var appeared = false

    @Binding var hapticGenerator: UISelectionFeedbackGenerator?

    init(
        variable: Binding<Int>,
        title: String,
        maxValue: Int,
        stepValue: Int,
        unit: String,
        itemWidth: CGFloat,
        itemSpacing: CGFloat,
        secondaryUnit: String,
        secondaryValue: String,
        fillColor: Color? = nil,
        hapticGenerator: Binding<UISelectionFeedbackGenerator?>) {

            self._variable = variable
            self._hapticGenerator = hapticGenerator

            self.title = title
            self.maxValue = maxValue
            self.stepValue = stepValue
            self.unit = unit
            self.itemWidth = itemWidth
            self.itemSpacing = itemSpacing
            self.secondaryUnit = secondaryUnit
            self.secondaryValue = secondaryValue

            self.fillColor = fillColor ?? .secondary.opacity(0.1)
        }

    var body: some View {

        GeometryReader { proxy in
            ZStack(alignment: .top) {

                ScrollViewReader { reader in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: itemSpacing) {

                            ForEach(Array(0...maxValue), id: \.self) { value in

                                let calculatedTickHeight = tickHeight(for: value)
                                let tickColor = isProminent(for: value) ? Color.black : Color.secondary

                                TickView(color: tickColor, tickWidth: itemWidth, tickHeight: calculatedTickHeight)
                                    .id(value)
                                    .overlay(numberIndicator(for: value), alignment: .bottom)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear.preference(
                                                key: CenteredValueKey.self,
                                                value: CenteredItem(
                                                    value: value,
                                                    distance: abs(geo.frame(in:.global).midX - UIScreen.main.bounds.midX)))
                                        })
                            }
                        }
                        .frame(height: 150, alignment: .bottom)
                        .padding(.bottom, 50)
                        .scrollTargetLayout()
                    }
                    .onScrollPhaseChange { oldPhase, newPhase in
                        isUserScrolling = newPhase == .interacting || newPhase == .decelerating
                    }
                    .task {

                        await MainActor.run {

                            reader.scrollTo(variable, anchor: .leading)
                            appeared = true
                        }
                    }
                    .onChange(of: variable) {

                        guard appeared == true else { return }
                        guard !isUserScrolling else { return }

                        reader.scrollTo(variable, anchor: .leading)
                    }
                    .contentMargins(.horizontal, proxy.size.width / 2)
                    .scrollTargetBehavior(CustomSnapBehaviour(itemWidth: itemWidth, itemSpacing: itemSpacing))
                    .defaultScrollAnchor(.leading)
                    .onPreferenceChange(CenteredValueKey.self) { item in

                        guard appeared == true else { return }

                        if variable != item.value {
                            if isUserScrolling {
                                hapticGenerator?.selectionChanged()
                            }
                            variable = item.value
                        }
                    }
                }

                scaleLabels

                Rectangle()
                    .fill(Color.red)
                    .frame(width: itemWidth + 0.5, height: 40)
                    .offset(x: 1, y: 110)
                    .allowsHitTesting(false)
            }
            .background(fillColor)
        }
    }

    private var scaleLabels: some View {

        VStack(spacing: 0) {
            HStack(alignment: .top) {

                Text("\(title)")
                    .font(.custom("HelveticaNeue", size: 25.0))
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .allowsHitTesting(false)

                Spacer()

                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        Text("\(variable)")
                            .font(.custom("HelveticaNeue", size: 70.0))
                            .fontWeight(.light)
                            .offset(y: -2.0)
                            .allowsHitTesting(false)

                        Text("\(unit)")
                            .font(.custom("HelveticaNeue-Thin", size: 40.0))
                            .allowsHitTesting(false)
                    }

                    if secondaryUnit.isEmpty == false {
                        HStack(alignment: .top) {
                            Text("\(secondaryValue)")
                                .font(.custom("HelveticaNeue", size: 20.0))
                                .fontWeight(.light)
                                .allowsHitTesting(false)

                            Text("\(secondaryUnit)")
                                .font(.custom("HelveticaNeue-Thin", size: 20.0))
                                .allowsHitTesting(false)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    func numberIndicator(for val: Int) -> some View {

        if val % 10 == 0 {
            Text("\(val)")
                .font(.caption)
                .frame(width: 30)
                .offset(y: 30)
        } else {
            EmptyView()
        }
    }

    func tickHeight(for val: Int) -> CGFloat {

        if val % 10 == 0 {
            return 20
        }

        if val % 5 == 0 {
            return 15
        }

        return 10
    }

    func isProminent(for val: Int) -> Bool {

        val % 10 == 0
    }
}

#Preview {
    @Previewable @State var value: Int = 40
    @Previewable @State var secondaryValue: String = "0.15"
    @Previewable @State var haptic: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()

    LinkedScaleView(variable: $value, title: Constants.flour, maxValue: 100, stepValue: 1, unit: "g", itemWidth: 2.0, itemSpacing: 10.0, secondaryUnit: "cups", secondaryValue: secondaryValue, hapticGenerator: $haptic)
        .padding(.vertical, 20.0)
}
