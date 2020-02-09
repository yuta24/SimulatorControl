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

    var selected: DeviceExt

    @State private var appearance: Xcrun.Appearance = .unknown

    var body: some View {
        self.appearance = (xcrun.appearance(udid: self.selected.device.udid)?.trimmingCharacters(in: .whitespacesAndNewlines))
            .flatMap(Xcrun.Appearance.init(rawValue:)) ?? .unknown

        // FIXME: Improve rendering performance
        return ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(selected.device.name)
                        .font(.title)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }

                if selected.runtime != nil {
                    HStack {
                        Text("\(selected.runtime!.name) (\(selected.runtime!.buildversion))")

                        Spacer()
                    }
                } else {
                    HStack {
                        Text("\(selected.device.availabilityError!)")
                            .foregroundColor(.red)

                        Spacer()
                    }
                }

                HStack {
                    Text("UDID: ")
                    Text(selected.device.udid)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }

                HStack {
                    Text("State: ")
                    Text(selected.device.state)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }

                Divider()

                HStack {
                    Text("Appearance: ")
                    Text("\(appearance.rawValue)")

                    Spacer()

                    if appearance.isSupported {
                        Button("Toggle") {
                            self.appearance.toggle()
                            xcrun.setAppearance(appearance: self.appearance.rawValue, to: self.selected.device.udid)
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
        selected: DeviceExt
    ) {
        self.store = store
        self.selected = selected
    }
}

//struct DeviceDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceDetailView(store: .init(initial: .init(), reducer: { _, _ in [] }))
//    }
//}
