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

            var booting: Bool {
                if case .booted = self {
                    return true
                } else {
                    return false
                }
            }
        }

        let state: State
        let isAvailable: Bool
        let name: String
        let udid: String
        let availabilityError: String?
        let dataPath: String
        let logPath: String
        let deviceTypeIdentifier: String?

        var dataPathUrl: URL {
            URL(fileURLWithPath: dataPath.replacingOccurrences(of: "\\", with: ""))
        }
        var logPathUrl: URL {
            URL(fileURLWithPath: logPath.replacingOccurrences(of: "\\", with: ""))
        }
    }
}
