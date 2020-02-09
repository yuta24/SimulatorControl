//
//  Service.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

extension Xcrun {
    class Service {
        enum Failure: Error {
            case process(String)
        }

        func boot(udid: String) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
            process.arguments = ["simctl", "boot", "\(udid)"]
            execute(process)
        }

        func shutdown(udid: String) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
            process.arguments = ["simctl", "shutdown", "\(udid)"]
            execute(process)
        }

        func list() -> SimCtlList? {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
            process.arguments = ["simctl", "list", "-j"]

            switch execute(process) {
            case .success(let data):
                return try? JSONDecoder().decode(SimCtlList.self, from: data)
            case .failure(let error):
                debugPrint(error)
                return nil
            }
        }

        func deleteUnavailable() {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
            process.arguments = ["simctl", "delete", "unavailable"]
            execute(process)
        }

        func appearance(udid: String) -> String? {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
            process.arguments = ["simctl", "ui", "\(udid)", "appearance"]

            switch execute(process) {
            case .success(let data):
                return String(data: data, encoding: .utf8)
            case .failure(let error):
                debugPrint(error)
                return nil
            }
        }

        func setAppearance(appearance: String, to udid: String) {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
            process.arguments = ["simctl", "ui", "\(udid)", "appearance", "\(appearance)"]
            execute(process)
        }

        @discardableResult
        private func execute(_ process: Process) -> Result<Data, Error> {
            let inpipe  = Pipe()
            let outpipe = Pipe()
            let errpipe = Pipe()

            process.standardOutput = inpipe
            process.standardOutput = outpipe
            process.standardError = errpipe

            try! process.run()

            let output = outpipe.fileHandleForReading.readDataToEndOfFile()
            let err = errpipe.fileHandleForReading.readDataToEndOfFile()

            if !output.isEmpty {
                return .success(output)
            } else {
                return .failure(Failure.process(String(data: err, encoding: .utf8)!))
            }
        }
    }
}
