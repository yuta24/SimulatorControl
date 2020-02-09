//
//  DeviceDetailView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/08.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

struct DeviceDetailView: View {
    @ObservedObject var store: Store<SCState, SCMessage>

    var selectedDevice: DeviceExt

    @State private var appearance: Xcrun.Appearance = .unknown

    var body: some View {
        self.appearance = (xcrun.appearance(udid: self.selectedDevice.device.udid)?.trimmingCharacters(in: .whitespacesAndNewlines))
            .flatMap(Xcrun.Appearance.init(rawValue:)) ?? .unknown

        // FIXME: Improve rendering performance
        return ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Name: ")
                    Text(selectedDevice.device.name)
                        .multilineTextAlignment(.leading)
                }

                HStack {
                    Text("UDID: ")
                    Text(selectedDevice.device.udid)
                        .multilineTextAlignment(.leading)
                }

                HStack {
                    Text("State: ")
                    Text(selectedDevice.device.state)
                        .multilineTextAlignment(.leading)
                }

                Divider()

                HStack {
                    Text("Appearance: ")
                    Text("\(appearance.rawValue)")

                    Spacer()

                    if appearance.isSupported {
                        Button("Toggle") {
                            self.appearance.toggle()
                            xcrun.setAppearance(appearance: self.appearance.rawValue, to: self.selectedDevice.device.udid)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 700)
    }

    init(
        store: Store<SCState, SCMessage>,
        selectedDevice: DeviceExt
    ) {
        self.store = store
        self.selectedDevice = selectedDevice
    }
}

//struct DeviceDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceDetailView(store: .init(initial: .init(), reducer: { _, _ in [] }))
//    }
//}
