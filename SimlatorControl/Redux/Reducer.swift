//
//  Reducer.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Cocoa

func reducer( state: inout SCState, message: SCMessage) -> [Effect<SCMessage>] {
    switch message {
    case .prepare:
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = ["simctl", "list", "-j"]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()

        let readHandle = pipe.fileHandleForReading
        let data = readHandle.readDataToEndOfFile()

        do {
            let output = try JSONDecoder().decode(SimCtlList.self, from: data)
            debugPrint(output)
            return [.sync(work: { () -> SCMessage in
                .prepared(output)
            })]
        } catch let error {
            debugPrint(error)
            return []
        }

    case .prepared(let list):
        state.simCtlList = list

        return []
    }
}
