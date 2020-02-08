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
    @State var showBootedOnly: Bool = false

    var body: some View {
        let devices: [Device] = {
            var devices = store.state.simCtlList.devices
                .map { $0.1 }
                .flatMap { $0 }

            if showBootedOnly {
                devices.removeAll(where: { $0.state.lowercased() != "booted" })
            }

            return devices
        }()

        return VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: self.$showBootedOnly) {
                Text("Booted only")
            }
            .padding(.top, 8)
            .padding(.leading, 12)

            List(devices, id: \.udid) { device in
                HStack(spacing: 8) {
                    if device.state.lowercased() == "booted" {
                        Circle().fill(Color.green)
                            .fixedSize()
                    } else if device.state.lowercased() == "shutdown" {
                        Circle().strokeBorder()
                            .fixedSize()
                    }

                    Text("\(device.name)").onTapGesture {
                        self.selectedDevice = device
                    }

                    Spacer()
                }
            }
            .listStyle(SidebarListStyle())
        }
        .frame(minWidth: 225, maxWidth: 400)
    }
}

//struct DevicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DevicesView(store: .init(initial: .init(), reducer: { _, _ in [] }), selectedDevice: <#Binding<Device?>#>)
//    }
//}
