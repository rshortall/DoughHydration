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

    @State private var isUserScrolling = false

    @State private var appeared = false

    @Binding var hapticGenerator: UISelectionFeedbackGenerator?

    var body: some View {

        GeometryReader { proxy in
            ZStack(alignment: .top) {

                ScrollViewReader { reader in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: itemSpacing) {

                            ForEach(0..<range) { value in

                                let calculatedTickHeight = tickHeight(for: value)

                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(width: itemWidth, height: calculatedTickHeight)
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

                VStack(spacing: 0) {
                    HStack(alignment: .top) {

                        Text("\(title)")
                            .font(.custom("HelveticaNeue", size: 25.0))
                            .fontWeight(.light)
                            .padding(.top, 10)
                            .allowsHitTesting(false)

                        Spacer()

                        VStack {
                            HStack(alignment: .top, spacing: 0) {
                                Text("\(variable)")
                                    .font(.custom("HelveticaNeue", size: 70.0))
                                    .fontWeight(.light)
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

//                    Rectangle()
//                        .fill(Color.red)
//                        .frame(width: itemWidth + 0.5, height: 40)
//                        .offset(x: 1, y: 28)
//                        .allowsHitTesting(false)
                }

                Rectangle()
                    .fill(Color.red)
                    .frame(width: itemWidth + 0.5, height: 40)
                    .offset(x: 1, y: 110)
                    .allowsHitTesting(false)
            }
            .background(.secondary.opacity(0.2))
        }
        .onAppear {
            print("Initial val \(title): \(variable)")
        }
    }

    var range: Int {

        maxValue + 1
    }

    @ViewBuilder
    func numberIndicator(for val: Int) -> some View {

        if val % 10 == 0 {
            Text("\(val)")
                .font(.caption)
                .frame(width: 30)
                .offset(y: 40)
        } else {
            EmptyView()
        }
    }

    func tickHeight(for val: Int) -> CGFloat {

        if abs(val - variable) < 3 {

            return 40 - (CGFloat(abs(val - variable)) * 12)
        }

        if val % 10 == 0 {
            return 20
        }

        if val % 5 == 0 {
            return 12
        }

        return 10
    }
}

#Preview {
    @Previewable @State var value: Int = 40
    @Previewable @State var secondaryValue: String = "0.15"
    @Previewable @State var haptic: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()

    LinkedScaleView(variable: $value, title: "Dough", maxValue: 100, stepValue: 1, unit: "g", itemWidth: 2.0, itemSpacing: 10.0, secondaryUnit: "cups", secondaryValue: secondaryValue, hapticGenerator: $haptic)
        .padding(.vertical, 20.0)
}
