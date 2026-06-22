//
//  Preset.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 19/06/2026.
//

import Foundation

struct Preset: Codable, Identifiable, Hashable {
    let title: String
    let flour: Int
    let water: Int
    var isActive: Bool

    var id: String { title }
}
