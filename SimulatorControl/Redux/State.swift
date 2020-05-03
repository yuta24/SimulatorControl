//
//  State.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

struct DeviceExt: Identifiable {
    var device: CLI.Simctl.Device
    var deviceType: CLI.Simctl.DeviceType?
    var runtime: CLI.Simctl.Runtime?

    var id: String {
        device.udid
    }
}

struct AppExt: Identifiable {
    var app: CLI.Simctl.App

    var id: String {
        app.bundleIdentifier
    }
}

struct DeviceDetailState {
    var ext: DeviceExt
    var appearance: CLI.Simctl.Appearance
    var apps: [CLI.Simctl.App]
    var recording: (Operation, String)?
}

struct AppDetialState {
    var appExt: AppExt
}

struct State {
    static var empty: State {
        .init(exts: [], deviceDetail: nil)
    }

    var exts: [DeviceExt]
    var deviceDetail: DeviceDetailState?
    var appDetail: AppDetialState?
}
