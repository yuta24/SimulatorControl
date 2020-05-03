//
//  Simctl.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/04/29.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Combine

struct ProcessSubscription: Subscription {
    let combineIdentifier: CombineIdentifier
    let operatoin: Operation

    func request(_ demand: Subscribers.Demand) {
        operatoin.start()
    }

    func cancel() {
        operatoin.cancel()
    }
}

struct ProcessPublisher: Publisher {
    typealias Output = Data
    struct Failure: Error {
        let content: String
    }

    private let operation: Operation
    private let outputPipe: Pipe
    private let errorPipe: Pipe

    init(_ process: Process) {
        self.outputPipe = Pipe()
        self.errorPipe = Pipe()

        self.operation = AsyncOperation {
            try! process.run()
            process.waitUntilExit()
        }

        process.standardOutput = outputPipe
        process.standardError = errorPipe
    }

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        operation.completionBlock = {
            let output = self.outputPipe.fileHandleForReading.readDataToEndOfFile()
            let error = self.errorPipe.fileHandleForReading.readDataToEndOfFile()

            if !output.isEmpty {
                _ = subscriber.receive(output)
                subscriber.receive(completion: .finished)
            } else {
                subscriber.receive(completion: .failure(Failure(content: String(data: error, encoding: .utf8)!)))
            }
        }

        let subscription = ProcessSubscription(combineIdentifier: .init(), operatoin: operation)
        subscriber.receive(subscription: subscription)
    }
}

extension Process {
    static func simctl(_ arguments: [String]) -> Process {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
        process.arguments = ["simctl"] + arguments
        return process
    }
}

extension CLI {
    enum Simctl {
        enum Error: Swift.Error {
            case process(String)
            case writeToFile(String)
            case parse(Swift.Error)
            case unknown
        }

        private static func run(_ process: Process) -> Result<Data, Error> {
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
                return .failure(.process(String(data: err, encoding: .utf8)!))
            }
        }

        struct Boot {
            let udid: String

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["boot", udid]))
                    .map { _ in () }
                    .mapError { Error.process($0.content) }
                    .eraseToAnyPublisher()
            }
        }

        struct Shutdown {
            let udid: String

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["shutdown", "boot", udid]))
                    .map { _ in () }
                    .mapError { Error.process($0.content) }
                    .eraseToAnyPublisher()
            }
        }

        struct List {
            func execute() -> AnyPublisher<SimCtlList, Error> {
                return ProcessPublisher(Process.simctl(["list", "-j"]))
                    .mapError { Error.process($0.content) }
                    .tryMap { try JSONDecoder().decode(SimCtlList.self, from: $0) }
                    .mapError { Error.parse($0) }
                    .eraseToAnyPublisher()
            }
        }

        struct DeleteUnavailable {
            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["delete", "unavailable"]))
                    .map { _ in () }
                    .mapError { Error.process($0.content) }
                    .eraseToAnyPublisher()
            }
        }

        struct StartRecording {
            let udid: String
            let path: URL

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["io", "\(udid)", "recordVideo", "--force", "\(path.absoluteString)"]))
                    .map { _ in () }
                    .mapError { Error.process($0.content) }
                    .eraseToAnyPublisher()
            }
        }

        struct FetchAppearance {
            let udid: String

            func execute() -> AnyPublisher<String?, Error> {
                return ProcessPublisher(Process.simctl(["ui", "\(udid)", "appearance"]))
                    .map { String(data: $0, encoding: .utf8) }
                    .mapError { Error.process($0.content) }
                    .eraseToAnyPublisher()
            }
        }

        struct UpdateAppearance {
            let udid: String
            let appearance: Appearance

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["ui", "\(udid)", "appearance", "\(appearance.rawValue)"]))
                    .map { _ in () }
                    .mapError { Error.process($0.content) }
                    .eraseToAnyPublisher()
            }
        }

        struct FetchApps {
            let udid: String

            func execute() -> AnyPublisher<[String: App], Error> {
                return ProcessPublisher(Process.simctl(["listapps", "\(udid)"]))
                    .mapError { Error.process($0.content) }
                    .tryMap { try PropertyListDecoder().decode([String: App].self, from: $0) }
                    .mapError { Error.parse($0) }
                    .eraseToAnyPublisher()
            }
        }

        struct SendPushNotification {
            let udid: String
            let bundleIdentifier: String
            let apns: String

            func execute() -> AnyPublisher<Void, Error> {
                let path = "/var/tmp/\(bundleIdentifier).apns"

                return Deferred {
                    Future<Void, Swift.Error> { callback in
                        do {
                            try self.apns.data(using: .utf8)?.write(to: URL(fileURLWithPath: path))
                            callback(.success(()))
                        } catch let error {
                            callback(.failure(error))
                        }
                    }
                }
                .mapError { _ in Error.unknown }
                .flatMap { _ in
                    ProcessPublisher(Process.simctl(["push", "\(self.udid)", "\(self.bundleIdentifier)", "\(path)"]))
                        .mapError { Error.process($0.content) }
                }
                .map { _ in () }
                .eraseToAnyPublisher()
            }
        }

        enum Command {
            case shutdown(String)
            case list

            fileprivate var arguments: [String] {
                switch self {
                case .shutdown(let udid):
                    return ["shutdown", udid]
                case .list:
                    return ["list", "-j"]
                }
            }
        }
    }
}
