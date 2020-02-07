//
//  DevicesView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/08.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

struct DevicesView: View {
    @ObservedObject var store: Store<SCState, SCMessage>

    var body: some View {
        let devices = store.state.simCtlList.devices.map { $0.1 }.flatMap { $0 }

        return List(devices, id: \.udid) { device in
            Text(device.name)
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(store: .init(initial: .init(), reducer: { _, _ in [] }))
    }
}
