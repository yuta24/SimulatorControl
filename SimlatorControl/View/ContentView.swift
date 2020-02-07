//
//  ContentView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<SCState, SCMessage>

    @State private var selectedDevice: Device?

    var body: some View {
        NavigationView {
            DevicesView(store: self.store)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(initial: .init(), reducer: { _, _ in [] }))
    }
}
