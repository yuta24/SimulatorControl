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

    private let executeBlock: () -> Void
    private let cancelBlock: () -> Void
    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false

    init(_ executeBlock: @escaping () -> Void, cancelBlock: @escaping () -> Void = {}) {
        self.executeBlock = executeBlock
        self.cancelBlock = cancelBlock
    }

    override func start() {
        isExecuting = true
        executeBlock()
        isExecuting = false
        isFinished = true
    }

    override func cancel() {
        cancelBlock()
    }
}
