//
//  Device.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension Xcrun {
    struct Device: Equatable, Decodable {
        enum State: String, Decodable {
            case booted = "Booted"
            case shutdown = "Shutdown"
        }

        let availabilityError: String?
        let dataPath: String
        let logPath: String
        let udid: String
        let isAvailable: Bool
        let deviceTypeIdentifier: String
        let state: State
        let name: String

        var dataPathUrl: URL {
            URL(fileURLWithPath: dataPath.replacingOccurrences(of: "\\", with: ""))
        }
        var logPathUrl: URL {
            URL(fileURLWithPath: logPath.replacingOccurrences(of: "\\", with: ""))
        }
    }
}
