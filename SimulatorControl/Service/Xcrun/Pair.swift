//
//  Pair.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension Xcrun {
    struct Pair: Decodable {
        struct Device: Decodable {
            let name: String?
            let udid: String?
            let state: String?
        }

        let watch: Device?
        let phone: Device?
        let state: String?
    }
}
