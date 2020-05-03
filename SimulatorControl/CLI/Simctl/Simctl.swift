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
    typealias Failure = Never

    private let operation: Operation
    private let outputPipe: Pipe
    private let errorPipe: Pipe

    init(_ process: Process) {
        self.outputPipe = Pipe()
        self.errorPipe = Pipe()


        self.operation = AsyncOperation({
            try! process.run()
            process.waitUntilExit()
        }) {
        }

        process.standardOutput = outputPipe
        process.standardError = errorPipe
    }

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        operation.completionBlock = {
            let output = self.outputPipe.fileHandleForReading.readDataToEndOfFile()

            _ = subscriber.receive(output)
            subscriber.receive(completion: .finished)
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
            case process
            case writeToFile(String)
            case parse(Swift.Error)
            case unknown
        }

        struct Boot {
            let udid: String

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["boot", udid]))
                    .map { _ in () }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        struct Shutdown {
            let udid: String

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["shutdown", "boot", udid]))
                    .map { _ in () }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        struct List {
            func execute() -> AnyPublisher<SimCtlList, Error> {
                return ProcessPublisher(Process.simctl(["list", "-j"]))
                    .setFailureType(to: Error.self)
                    .tryMap { try JSONDecoder().decode(SimCtlList.self, from: $0) }
                    .mapError { Error.parse($0) }
                    .eraseToAnyPublisher()
            }
        }

        struct DeleteUnavailable {
            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["delete", "unavailable"]))
                    .map { _ in () }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        struct FetchAppearance {
            let udid: String

            func execute() -> AnyPublisher<Appearance, Error> {
                return ProcessPublisher(Process.simctl(["ui", "\(udid)", "appearance"]))
                    .map { String(data: $0, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .map { $0.flatMap(Appearance.init(rawValue:)) ?? .unknown }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        struct UpdateAppearance {
            let udid: String
            let appearance: Appearance

            func execute() -> AnyPublisher<Void, Error> {
                return ProcessPublisher(Process.simctl(["ui", "\(udid)", "appearance", "\(appearance.rawValue)"]))
                    .map { _ in () }
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        }

        struct FetchApps {
            let udid: String

            func execute() -> AnyPublisher<[String: App], Error> {
                return ProcessPublisher(Process.simctl(["listapps", "\(udid)"]))
                    .setFailureType(to: Error.self)
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
                        .setFailureType(to: Error.self)
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
