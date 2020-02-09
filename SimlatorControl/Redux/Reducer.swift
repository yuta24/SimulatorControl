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
        if let list = xcrun.list() {
            return [.sync(work: { () -> SCMessage in
                .prepared(list)
            })
            ]
        } else {
            return []
        }
    case .prepared(let list):
        state.simCtlList = list

        return []

    case .terminate:

        return []
    }
}
