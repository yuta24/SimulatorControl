//
//  Event.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/05/03.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

enum Event {
    case prepare
    case terminate

    case boot(CLI.Simctl.Device)
    case shutdown(CLI.Simctl.Device)
    case startRecording(CLI.Simctl.Device)
    case stopRecording
    case deleteUnavailable
    case fetch
    case select(DeviceExt)
    case updateAppearance(String, CLI.Simctl.Appearance)
    case toggleAppearance(String)

    case sendPush(CLI.Simctl.Device, CLI.Simctl.App, String)
}
