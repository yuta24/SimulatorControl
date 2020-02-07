//
//  SimCtlList.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

struct SimCtlList: Decodable {
    let devicetypes: [DeviceType]
    let runtimes: [Runtime]
    let devices: [String: [Device]]
    let pairs: [String: Pair]
}
