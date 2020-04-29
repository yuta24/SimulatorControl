//
//  Global.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

let xcrun = Xcrun.Service()
let store = Store<State, SCMessage>(initial: .empty, reducer: reducer)
