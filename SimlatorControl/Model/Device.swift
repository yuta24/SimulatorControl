//
//  Device.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

struct Device: Equatable, Decodable {
    let availabilityError: String?
    let dataPath: String
    let logPath: String
    let udid: String
    let isAvailable: Bool
    let deviceTypeIdentifier: String
    let state: String
    let name: String
}
