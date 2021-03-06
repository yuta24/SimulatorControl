//
//  MainView.swift
//  SimlatorControl
//
//  Created by Yu Tawata on 2020/02/07.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI
import Helix

struct MainView: View {
    @ObservedObject var store: Store<State, Event, Mutate>

    var body: some View {
        NavigationView {
            DevicesView(store: store)
            DeviceDetailView(store: store)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: .init(state: .empty, reducer: reducer, executor: executor))
    }
}
