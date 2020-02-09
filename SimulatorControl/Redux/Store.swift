//
//  Store.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Combine

struct Effect<Output>: Publisher {
    typealias Failure = Never

    let publisher: AnyPublisher<Output, Failure>

    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        self.publisher.receive(subscriber: subscriber)
    }
}

extension Effect {
    static func fireAndForget(work: @escaping () -> Void) -> Effect {
        return Deferred { () -> Empty<Output, Never> in
            work()
            return Empty(completeImmediately: true)
        }.eraseToEffect()
    }

    static func sync(work: @escaping () -> Output) -> Effect {
        return Deferred {
            Just(work())
        }.eraseToEffect()
    }

    static func async(work: @escaping (@escaping (Output) -> Void) -> Void) -> Effect {
        return Deferred {
            Future { callback in
                work { output in
                    callback(.success(output))
                }
            }
        }
        .eraseToEffect()
    }
}

extension Publisher where Failure == Never {
    func eraseToEffect() -> Effect<Output> {
        return Effect(publisher: self.eraseToAnyPublisher())
    }
}

typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

class Store<State, Message>: ObservableObject {
    @Published private(set) var state: State

    private let reducer: Reducer<State, Message>
    private var cancellables = Set<AnyCancellable>()

    init(initial state: State, reducer: @escaping Reducer<State, Message>) {
        self.state = state
        self.reducer = reducer
    }

    func send(_ message: Message) {
        let effects = self.reducer(&self.state, message)

        effects.forEach { effect in
            var effectCancellable: AnyCancellable?
            var didComplete = false
            effectCancellable = effect.sink(
                receiveCompletion: { [weak self] _ in
                didComplete = true
                guard let effectCancellable = effectCancellable else { return }
                self?.cancellables.remove(effectCancellable)
            },
                receiveValue: self.send
            )
            if !didComplete, let effectCancellable = effectCancellable {
                self.cancellables.insert(effectCancellable)
            }
        }
    }
}
