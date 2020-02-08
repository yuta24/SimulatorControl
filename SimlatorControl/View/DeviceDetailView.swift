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

    var body: some View {
        ScrollView {
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
            }
        }
        .padding()
        .frame(maxWidth: 700)
    }
}

//struct DeviceDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceDetailView(store: .init(initial: .init(), reducer: { _, _ in [] }))
//    }
//}
