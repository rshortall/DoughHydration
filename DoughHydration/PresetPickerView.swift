//
//  PresetPickerView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 19/06/2026.
//

import SwiftUI

struct PresetTest {

    var isActive: Bool
    let name: String
}

struct PresetPickerView: View {

    let presets: [Preset]

    let saveSelection: ([Preset]) -> Void

    @State private var selectedItems: [Preset] = []

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {
            VStack {

                List(presets) { item in

                    HStack {
                        Text(item.title)

                        Spacer()

                        if selectedItems.contains(item) {
                            Circle()
                                .frame(width: 26)
                                .foregroundStyle(.green)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10)
                                        .foregroundStyle(.white)
                                )
                        } else {
                            Image(systemName: "circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26)
                                .foregroundStyle(Color.secondary.opacity(0.5))
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedItems.contains(item) {
                            selectedItems.removeAll(where: { $0.title == item.title })
                        } else {
                            selectedItems.append(item)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)

                Button {
                    saveActivePresets()
                } label: {
                    Text("Save")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
                .padding()
                .buttonStyle(.bordered)
                .foregroundStyle(Color.primary)
            }
            .padding()
            .onAppear {
                selectedItems = presets.filter { $0.isActive }
            }
            .navigationTitle("Preset Measurements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }

    private func saveActivePresets() {

        var updatedPresets: [Preset] = []
        presets.forEach { preset in
            var upatedPreset = preset
            upatedPreset.isActive = selectedItems.contains(where: { $0.title == preset.title })
            updatedPresets.append(upatedPreset)
        }

        self.saveSelection(updatedPresets)
        self.dismiss()
    }
}

#Preview {
    let presets = [
        Preset(title: "White Bread", flour: 500, water: 300, isActive: true),
        Preset(title: "Pizza", flour: 500, water: 325, isActive: true),
        Preset(title: "Bagels", flour: 550, water: 308, isActive: true),
        Preset(title: "Focaccia", flour: 550, water: 412, isActive: true)
    ]

    return PresetPickerView(presets: presets) { presets in

    }
}
