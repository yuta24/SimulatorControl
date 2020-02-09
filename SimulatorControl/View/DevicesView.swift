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
    @Binding var selectedDevice: DeviceExt?
    @State var showBootedOnly: Bool = false

    var body: some View {
        let exts: [DeviceExt] = {
            var exts = store.state.exts

            if showBootedOnly {
                exts.removeAll(where: { $0.device.state.lowercased() != "booted" })
            }

            return exts
        }()

        return VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: self.$showBootedOnly) {
                Text("Booted only")
            }
            .padding(.top, 8)
            .padding(.leading, 12)

            List(exts) { ext in
                HStack(spacing: 8) {
                    if ext.device.state.lowercased() == "booted" {
                        Circle().fill(Color.green)
                            .fixedSize()
                    } else if ext.device.state.lowercased() == "shutdown" {
                        Circle().strokeBorder()
                            .fixedSize()
                    }

                    Text("\(ext.device.name)").onTapGesture {
                        self.selectedDevice = ext
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
//        DevicesView(store: .init(initial: .empty, reducer: { _, _ in [] }), selectedDevice: <#Binding<Device?>#>)
//    }
//}
