//
//  DeviceDetailView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/08.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

struct InstalledAppView: View {
    var apps: [App]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Installed Apps").font(.headline)

            ForEach(apps, id: \.bundleIdentifier) {
                Text($0.bundleDisplayName)
            }
        }
    }
}

struct DeviceDetailView: View {
    @ObservedObject var store: Store<SCState, SCMessage>

    var body: some View {
        guard let selected = store.state.detail else {
            return AnyView(EmptyView())
        }

        // FIXME: Improve rendering performance
        return AnyView(
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(selected.ext.device.name)
                            .font(.title)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }

                    if selected.ext.runtime != nil {
                        HStack {
                            Text("\(selected.ext.runtime!.name) (\(selected.ext.runtime!.buildversion))")

                            Spacer()
                        }
                    } else {
                        HStack {
                            Text("\(selected.ext.device.availabilityError!)")
                                .foregroundColor(.red)

                            Spacer()
                        }
                    }

                    HStack {
                        Text("UDID: \(selected.ext.device.udid)")
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }

                    HStack {
                        Text("Data: \(selected.ext.device.dataPath)").onTapGesture {
                            NSWorkspace.shared.activateFileViewerSelecting([selected.ext.device.dataPathUrl])
                        }
                    }

                    HStack {
                        Text("Log: \(selected.ext.device.logPath)").onTapGesture {
                            NSWorkspace.shared.activateFileViewerSelecting([selected.ext.device.logPathUrl])
                        }
                    }

                    HStack {
                        Text("State: \(selected.ext.device.state.rawValue)")
                            .multilineTextAlignment(.leading)

                        Spacer()

                        ViewBuilder.build { () -> AnyView in
                            switch selected.ext.device.state {
                            case .booted:
                                return AnyView(Button("Shutdown") {
                                    self.store.send(.shutdown(selected.ext.device))
                                })
                            case .shutdown:
                                return AnyView(Button("Boot") {
                                    self.store.send(.boot(selected.ext.device))
                                })
                            }
                        }
                    }

                    HStack {
                        Text("Appearance: \(selected.appearance.rawValue)")

                        Spacer()

                        if selected.appearance.isSupported {
                            Button("Toggle") {
                                var appearance = selected.appearance
                                appearance.toggle()
                                self.store.send(.setAppearance(appearance))
                            }
                        }
                    }

                    Divider()

                    InstalledAppView(apps: selected.apps)
                }
            }
            .padding()
            .frame(maxWidth: 700)
        )
    }

    init(store: Store<SCState, SCMessage>) {
        self.store = store
    }
}

//struct DeviceDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceDetailView(store: .init(initial: .init(), reducer: { _, _ in [] }))
//    }
//}
