//
//  SCMessage.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

enum SCMessage {
    case prepare
    case terminate

    case deleteUnavailable

    case boot(Xcrun.Device)
    case shutdown(Xcrun.Device)
    case startRecording(Xcrun.Device)
    case stopRecording

    case fetch
    case fetched(Xcrun.SimCtlList)
    case select(DeviceExt)
    case setAppearance(Xcrun.Appearance)

    case sendPush(Xcrun.Device, App, String)
}
