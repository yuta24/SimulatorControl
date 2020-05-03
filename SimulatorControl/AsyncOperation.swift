//
//  AsyncOperation.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/10.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }

        get {
            return _isFinished
        }
    }

    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }

        get {
            return _isExecuting
        }
    }

    override var isAsynchronous: Bool {
        return true
    }

    private let block: () -> Void
    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false

    init(_ block: @escaping () -> Void) {
        self.block = block
    }

    override func start() {
        isExecuting = true
        block()
        isExecuting = false
        isFinished = true
    }
}
