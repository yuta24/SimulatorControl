//
//  Reducer.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Cocoa

func reducer( state: inout SCState, message: SCMessage) -> [Effect<SCMessage>] {
    switch message {

    case .prepare:
        if let list = xcrun.list() {
            return [.sync(work: { () -> SCMessage in
                .prepared(list)
            })
            ]
        } else {
            return []
        }

    case .prepared(let list):
        state.exts = {
            let devices = list.devices.map { key, value in value.map { ($0, key) } }.flatMap { $0 }
            return devices.map { device in
                DeviceExt(
                    device: device.0,
                    deviceType: list.devicetypes.first(where: { device.0.deviceTypeIdentifier == $0.identifier }),
                    runtime: list.runtimes.first(where: { device.1 == $0.identifier }))
            }
        }()

        return []

    case .terminate:

        return []

    case .select(let ext):
        let appearance = (xcrun.appearance(udid: ext.device.udid)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    .flatMap(Xcrun.Appearance.init(rawValue:)) ?? .unknown
        state.detail = .init(ext: ext, appearance: appearance)

        return []

    case .setAppearance(let appearance):
        guard let ext = store.state.detail?.ext else {
            return []
        }

        xcrun.setAppearance(appearance: appearance.rawValue, to: ext.device.udid)
        state.detail?.appearance = appearance

        return []
    }
}
