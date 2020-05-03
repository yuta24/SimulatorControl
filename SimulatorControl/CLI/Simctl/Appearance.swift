//
//  Appearance.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension CLI.Simctl {
    enum Appearance: String {
        case light
        case dark
        case unsupported
        case unknown
    }
}

extension CLI.Simctl.Appearance {
    var isSupported: Bool {
        switch self {
        case .unsupported, .unknown:
            return false
        default:
            return true
        }
    }

    mutating func toggle() {
        switch self {
        case .light:
            self = .dark
        case .dark:
            self = .light
        default:
            break
        }
    }
}
