//
//  Reducer.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Helix

let reducer = Reducer<State, Mutate> { state, mutate in

    switch mutate {

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

    case .selected(let ext, let appearance, let apps):
        let apps = apps.values.filter({ $0.applicationType == .user })
        state.deviceDetail = .init(ext: ext, appearance: appearance, apps: apps, recording: .none)

    case .recording(let operation):
        state.deviceDetail?.recording = operation

    case .recorded:
        state.deviceDetail?.recording = .none

    case .appearanceUpdated(_, let appearance):
        state.deviceDetail?.appearance = appearance

    case .handleError(let error):
        // TODO: Impl
        break

    }

}
