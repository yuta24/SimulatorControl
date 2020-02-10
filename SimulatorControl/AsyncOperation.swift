//
//  AsyncOperation.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/10.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    var cancelBlock: () -> Void = {}

    private let lockQueue = DispatchQueue(label: "asyncOperation", attributes: .concurrent)
    private let block: () -> Void

    init(block: @escaping () -> Void) {
        self.block = block
    }

    override var isAsynchronous: Bool {
        return true
    }

    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
        }
    }

    override func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true
        main()
    }

    override func main() {
        lockQueue.async {
            self.block()
        }
    }

    override func cancel() {
        cancelBlock()
    }

    func finish() {
        if isCancelled {
            cancelBlock()
        }

        isExecuting = false
        isFinished = true
    }
}
