//
//  ScreenRecordingService.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Cocoa

class ScreenRecordingService {
    let udid: String

    private var handler: ((NSImage) -> Void)?
    private var timer: Timer?

    init(udid: String) {
        self.udid = udid
    }

    func start(interval: TimeInterval, handler: @escaping (NSImage) -> Void) {
        self.handler = handler
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            guard let nsImage = self?.capture() else {
                return
            }

            handler(nsImage)
        })
        timer?.fire()
    }

    func stop() {
        timer?.invalidate()
    }

    private func capture() -> NSImage? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = ["simctl", "io", "\(udid)", "screenshot", "/var/tmp/\(udid).png"]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()

        let image = NSImage(contentsOfFile: "/var/tmp/\(udid).png")
        return image
    }
}
