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
    @Binding var selectedDevice: Device?

    var body: some View {
        let devices = store.state.simCtlList.devices.map { $0.1 }.flatMap { $0 }

        return List(devices, id: \.udid) { device in
            Text(device.name).onTapGesture {
                self.selectedDevice = device
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 225, maxWidth: 300)
    }
}

//struct DevicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DevicesView(store: .init(initial: .init(), reducer: { _, _ in [] }), selectedDevice: <#Binding<Device?>#>)
//    }
//}
