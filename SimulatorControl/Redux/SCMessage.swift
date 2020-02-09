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
    case prepared(Xcrun.SimCtlList)
    case terminate

    case select(DeviceExt)
    case setAppearance(Xcrun.Appearance)
}