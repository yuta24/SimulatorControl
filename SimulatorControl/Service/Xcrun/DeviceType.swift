//
//  DeviceType.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension Xcrun {
    struct DeviceType: Decodable {
        let name: String?
        let bundlePath: String?
        let identifier: String?
        let minRuntimeVersion: Int?
        let maxRuntimeVersion: Int?
        let productFamily: String?
    }
}
