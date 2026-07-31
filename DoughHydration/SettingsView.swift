//
//  SettingsView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 22/06/2026.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("showPresets") var showPresets: Bool = true

    @AppStorage("showImperial") var showImperial: Bool = true

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Show Preset Buttons", isOn: $showPresets)
                } header: {
                    Text("Presets")
                }

                Section {
                    Toggle("Show Imperial Measurements", isOn: $showImperial)
                } header: {
                    Text("Units")
                }
            }
            .navigationBarTitle("Settings")
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
}

#Preview {
    SettingsView()
}
