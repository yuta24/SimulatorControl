//
//  AppDelegate.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine
#if DEBUG
import FirebaseCore
import FirebaseCrashlytics
#endif


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var statusItem: NSStatusItem!

    private var cancellable = Set<AnyCancellable>()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        #if DEBUG
        FirebaseApp.configure()
        #endif

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "Simulator"

        store.$state
            .sink(receiveValue: { [weak self] state in
                self?.makeStatusItem(state.exts)
            })
            .store(in: &cancellable)

        // Create the SwiftUI view that provides the window contents.
        store.handle(.prepare)

        let contentView = MainView(store: store)

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.title = "Simulator Control"
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func makeStatusItem(_ deviceExts: [DeviceExt]) {
        let menu = NSMenu()

        deviceExts.forEach { ext in
            let item = NSMenuItem()
            item.title = ext.device.name

            if ext.device.state.booting {
                let _menu = NSMenu()

                let _item = NSMenuItem()
                _item.title = "Toggle appearance"
                _item.representedObject = ext
                _item.action = #selector(onToggleAppearance(_:))

                _menu.addItem(_item)

                item.submenu = _menu
            }

            menu.addItem(item)
        }

        statusItem.menu = menu
    }

    @IBAction private func refresh(_ sender: AnyObject) {
        store.handle(.fetch)
    }

    @IBAction private func deleteUnavailable(_ sender: AnyObject) {
        store.handle(.deleteUnavailable)
    }

    @objc private func onToggleAppearance(_ sender: NSMenuItem) {
        guard let ext = sender.representedObject as? DeviceExt else {
            return
        }

        store.handle(.toggleAppearance(ext.device.udid))
    }
}
