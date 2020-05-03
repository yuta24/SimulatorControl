//
//  Global.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation
import Helix

let store = Store<State, Event, Mutate>(state: .empty, reducer: reducer, executor: executor)
