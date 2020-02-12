//
//  ViewBuilder.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

extension ViewBuilder {
    static func build<V>(_ block: () -> V) -> V where V: View {
        block()
    }
}
