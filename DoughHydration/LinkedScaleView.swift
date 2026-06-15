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

                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: itemWidth, height: tickHeight(for: value))
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
//                    .onAppear {
//
//                        print("Setting initial scale value to: ", variable)
//
//                        reader.scrollTo(variable, anchor: .leading)
//                        appeared = true
//                    }
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

                        Spacer()

                        HStack(alignment: .top, spacing: 0) {
                            Text("\(variable)")
                                .font(.custom("HelveticaNeue", size: 70.0))
                                .fontWeight(.light)

                            Text("\(unit)")
                                .font(.custom("HelveticaNeue-Thin", size: 40.0))
                        }
                    }

                    Image(systemName: "triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(.degrees(180.0))
                        .frame(height: 15)
                        .padding(.bottom, 10)
                }
            }
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

        if val % 10 == 0 {
            return 30
        }

        if val % 5 == 0 {
            return 15
        }

        return 10
    }
}

#Preview {
    @Previewable @State var value: Int = 40
    @Previewable @State var haptic: UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()

    LinkedScaleView(variable: $value, title: "Dough", maxValue: 100, stepValue: 1, unit: "g", itemWidth: 2.0, itemSpacing: 10.0, hapticGenerator: $haptic)
        .padding(20.0)
}
