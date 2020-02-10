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
        return [
            .sync(work: { () -> SCMessage in
                .fetch
            })
        ]

    case .terminate:

        return []

    case .deleteUnavailable:
        xcrun.deleteUnavailable()

        return [
            .sync(work: { () -> SCMessage in
                .fetch
            })
        ]

    case .boot(let device):
        xcrun.boot(udid: device.udid)

        return [
            .sync(work: { () -> SCMessage in
                .fetch
            })
        ]

    case .shutdown(let device):
        xcrun.shutdown(udid: device.udid)

        return [
            .sync(work: { () -> SCMessage in
                .fetch
            })
        ]

    case .startRecording(let device):
        state.detail?.operation = xcrun.startRecording(udid: device.udid)

        return []

    case .stopRecording:
        if let operation = state.detail?.operation {
            operation.cancel()
        }
        state.detail?.operation = .none

        return []

    case .fetch:
        if let list = xcrun.list() {
            return [
                .sync(work: { () -> SCMessage in
                    .fetched(list)
                })
            ]
        } else {
            return []
        }

    case .fetched(let list):
        state.exts = {
            let devices = list.devices
                .map { key, value in value.map { ($0, key) } }
                .flatMap { $0 }

            return devices.map { device in
                DeviceExt(
                    device: device.0,
                    deviceType: list.devicetypes.first(where: { device.0.deviceTypeIdentifier == $0.identifier }),
                    runtime: list.runtimes.first(where: { device.1 == $0.identifier }))
            }
        }()

        return []

    case .select(let ext):
        if let operation = state.detail?.operation {
            operation.cancel()
        }

        let appearance = (xcrun.appearance(udid: ext.device.udid)?.trimmingCharacters(in: .whitespacesAndNewlines))
                    .flatMap(Xcrun.Appearance.init(rawValue:)) ?? .unknown
        let apps = xcrun.listApps(udid: ext.device.udid)
        state.detail = .init(ext: ext, appearance: appearance, apps: apps.values.filter({ $0.applicationType == .user }), operation: .none)

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
