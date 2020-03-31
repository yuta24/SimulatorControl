//
//  DeviceDetailView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/08.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

struct ControlAppView: View {
    @State private var apns: String = ""

    var push: (String) -> Void

    var body: some View {
        TabView {
            VStack(alignment: .leading, spacing: 8) {
                Text("APS")

                TextView(text: $apns)
                    .cornerRadius(4)
                    .frame(minHeight: 200, maxHeight: .infinity)

                HStack {
                    Spacer()

                    Button("Send") {
                        self.push(self.apns)
                    }
                    .disabled(apns.isEmpty)
                }
            }
            .padding()
            .tabItem({ Text("Send Push") })

//            HStack {
//                Text("")
//            }
//            .tabItem({ Text("Edit Defaults") })
        }
        .frame(height: 400)
    }
}

struct InstalledAppView: View {
    var apps: [App]
    var push: (App, String) -> Void

    @State private var selected: App?

    var body: some View {
        let label = selected ?? apps.first!

        return VStack(alignment: .leading, spacing: 8) {
            Text("Installed Apps").font(.subheadline)

            MenuButton(label.bundleDisplayName) {
                ForEach(apps, id: \.bundleIdentifier) { app in
                    Button(app.bundleDisplayName) {
                        self.selected = app
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Identifier").font(.caption).foregroundColor(.secondary)
                Text(label.bundleIdentifier)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Display Name").font(.caption).foregroundColor(.secondary)
                Text(label.bundleDisplayName)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Versioon").font(.caption).foregroundColor(.secondary)
                Text(label.bundleVersion)
            }

            if label.dataContainer != nil {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Data Container").font(.caption).foregroundColor(.secondary)
                    Text("\(label.dataContainer!)").onTapGesture {
                        NSWorkspace.shared.activateFileViewerSelecting([label.dataContainerUrl!])
                    }
                }
            }

            ControlAppView {
                self.push(label, $0)
            }
        }
    }
}

struct DeviceDetailView: View {
    @ObservedObject var store: Store<SCState, SCMessage>

    var body: some View {
        guard let selected = store.state.deviceDetail else {
            return AnyView(EmptyView())
        }

        // FIXME: Improve rendering performance
        return AnyView(
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(selected.ext.device.name)
                            .font(.headline)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        if selected.ext.device.state.booting {
                            if selected.recording == nil {
                                Button("Start recording") {
                                   self.store.send(.startRecording(selected.ext.device))
                                }
                            } else {
                                Button("Stop recording") {
                                    self.store.send(.stopRecording)
                                }
                            }
                        }
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

                    VStack(alignment: .leading, spacing: 4) {
                        Text("UDID").font(.caption).foregroundColor(.secondary)
                        Text("\(selected.ext.device.udid)")
                            .multilineTextAlignment(.leading)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Data").font(.caption).foregroundColor(.secondary)
                        Text("\(selected.ext.device.dataPath)").onTapGesture {
                            NSWorkspace.shared.activateFileViewerSelecting([selected.ext.device.dataPathUrl])
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Log").font(.caption).foregroundColor(.secondary)
                        Text("\(selected.ext.device.logPath)").onTapGesture {
                            NSWorkspace.shared.activateFileViewerSelecting([selected.ext.device.logPathUrl])
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("State").font(.caption).foregroundColor(.secondary)

                        HStack {
                            Text("\(selected.ext.device.state.rawValue)")
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
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Appearance").font(.caption).foregroundColor(.secondary)

                        HStack {
                            Text("\(selected.appearance.rawValue)")

                            Spacer()

                            if selected.appearance.isSupported {
                                Button("Toggle") {
                                    var appearance = selected.appearance
                                    appearance.toggle()
                                    self.store.send(.setAppearance(selected.ext.device.udid, appearance))
                                }
                            }
                        }
                    }

                    if !selected.apps.isEmpty {
                        Divider()

                        InstalledAppView(apps: selected.apps) { app, apns in
                            self.store.send(.sendPush(selected.ext.device, app, apns))
                        }
                    }
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
