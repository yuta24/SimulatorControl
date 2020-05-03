//
//  Mutate.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/05/03.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Combine

enum Mutate {
    case fetched(CLI.Simctl.SimCtlList)
    case selected(DeviceExt, CLI.Simctl.Appearance, [String: CLI.Simctl.App])
    case recording((Operation, String))
    case recorded
    case appearanceUpdated(String, CLI.Simctl.Appearance)
    case handleError(Error)
}
