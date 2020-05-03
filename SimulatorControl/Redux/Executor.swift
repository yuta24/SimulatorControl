//
//  Executor.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/05/03.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Combine
import Helix

let executor = Executor<State, Event, Mutate> { state, event -> AnyPublisher<Executor<State, Event, Mutate>.Result, Never> in

    switch event {

    case .prepare:
        return Just(.next(.fetch))
            .eraseToAnyPublisher()

    case .terminate:
        return Just(.end(.none))
            .eraseToAnyPublisher()

    case .boot(let device):
        return CLI.Simctl.Boot(udid: device.udid).execute()
            .map { .next(.fetch) }
            .catch { error in Just(.end(.handleError(error))) }
            .eraseToAnyPublisher()

    case .shutdown(let device):
        return CLI.Simctl.Shutdown(udid: device.udid).execute()
            .map { .next(.fetch) }
            .catch { error in Just(.end(.handleError(error))) }
            .eraseToAnyPublisher()

    case .startRecording(let device):
        // TODO: Impl
//        return CLI.Simctl.StartRecording(udid: device.udid, path: URL(fileURLWithPath: "/var/tmp/\(device.udid).mp4")).execute()
//            .map { .next(.fetch) }
//            .catch { _ in Just(.end(.none)) }
//            .eraseToAnyPublisher()
        return Just(.end(.none))
            .eraseToAnyPublisher()

    case .stopRecording:
        // TODO: Impl
        return Just(.end(.none))
            .eraseToAnyPublisher()

    case .deleteUnavailable:
        return CLI.Simctl.DeleteUnavailable().execute()
            .map { .next(.fetch) }
            .catch { error in Just(.end(.handleError(error))) }
            .eraseToAnyPublisher()

    case .fetch:
        return CLI.Simctl.List().execute()
            .map { .fetched($0) }
            .catch { Just(.handleError($0)) }
            .map { .end($0) }
            .eraseToAnyPublisher()

    case .select(let ext):
        return CLI.Simctl.FetchAppearance(udid: ext.device.udid).execute()
            .map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { $0.flatMap(CLI.Simctl.Appearance.init(rawValue:)) }
            .zip(CLI.Simctl.FetchApps(udid: ext.device.udid).execute())
            .map { .selected(ext, $0.0 ?? .unknown, $0.1) }
            .catch { Just(.handleError($0)) }
            .map { .end($0) }
            .eraseToAnyPublisher()

    case .updateAppearance(let udid, let appearance):
        return CLI.Simctl.UpdateAppearance(udid: udid, appearance: appearance).execute()
            .map { .appearanceUpdated(udid, appearance) }
            .catch { Just(.handleError($0)) }
            .map { .end($0) }
            .eraseToAnyPublisher()

    case .toggleAppearance(let uuid):
        // TODO: Impl
        return Just(.end(.none))
            .eraseToAnyPublisher()

    case .sendPush(let device, let app, let uuid):
        // TODO: Impl
        return Just(.end(.none))
            .eraseToAnyPublisher()

    }

}
