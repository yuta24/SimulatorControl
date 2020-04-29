//
//  DevicesView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/08.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

struct DevicesView: View {
    @SwiftUI.ObservedObject var store: Store<State, Message>
    @SwiftUI.State var showBootedOnly: Bool = false

    var body: some View {
        let exts: [DeviceExt] = {
            var exts = store.state.exts

            if showBootedOnly {
                exts.removeAll(where: { $0.device.state != .booted })
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
                    if ext.device.state == .booted {
                        Circle().fill(Color.green)
                            .fixedSize()
                    } else if ext.device.state == .shutdown {
                        Circle().strokeBorder()
                            .fixedSize()
                    }

                    Text("\(ext.device.name)")

                    Spacer()
                }
                .onTapGesture {
                    self.store.send(.select(ext))
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
