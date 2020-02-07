//
//  DeviceType.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

struct DeviceType: Decodable {
    let minRuntimeVersion: Int
    let bundlePath: String
    let maxRuntimeVersion: Int
    let name: String
    let identifier: String
    let productFamily: String
}
