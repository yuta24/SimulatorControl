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

    var selectedDevice: Device

    @State private var appearance: Appearance = .unknown

    var body: some View {
        self.appearance = (xcrun.appearance(udid: self.selectedDevice.udid)?.trimmingCharacters(in: .whitespacesAndNewlines))
            .flatMap(Appearance.init(rawValue:)) ?? .unknown

        // FIXME: Improve rendering performance
        return ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Name: ")
                    Text(selectedDevice.name)
                        .multilineTextAlignment(.leading)
                }

                HStack {
                    Text("UDID: ")
                    Text(selectedDevice.udid)
                        .multilineTextAlignment(.leading)
                }

                HStack {
                    Text("State: ")
                    Text(selectedDevice.state)
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
                            xcrun.setAppearance(appearance: self.appearance.rawValue, to: self.selectedDevice.udid)
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
        selectedDevice: Device
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
