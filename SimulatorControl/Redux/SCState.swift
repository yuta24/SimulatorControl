//
//  SCState.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

struct DeviceExt: Identifiable {
    var device: Xcrun.Device
    var deviceType: Xcrun.DeviceType?
    var runtime: Xcrun.Runtime?

    var id: String {
        device.udid
    }
}

struct DeviceDetailState {
    var ext: DeviceExt
    var appearance: Xcrun.Appearance
}

struct SCState {
    static var empty: SCState {
        .init(exts: [], detail: nil)
    }

    var exts: [DeviceExt]
    var detail: DeviceDetailState?
}
