//
//  Runtime.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension Xcrun {
    struct Runtime: Decodable {
        let bundlePath: String
        let buildversion: String
        let runtimeRoot: String
        let identifier: String
        let version: String
        let isAvailable: Bool
        let name: String
    }
}
