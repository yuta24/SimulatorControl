//
//  Global.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

let xcrun = XcrunService()
let store = Store<SCState, SCMessage>(initial: .init(), reducer: reducer)
