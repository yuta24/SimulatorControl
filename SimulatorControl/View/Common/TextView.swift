//
//  TextView.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/13.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Cocoa
import SwiftUI

struct TextView: NSViewRepresentable {
    class Coordinator: NSObject, NSTextViewDelegate {
        var target: TextView
        var selectedRanges = [NSValue]()

        init(_ target: TextView) {
            self.target = target
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            self.target.text = textView.string
            self.selectedRanges = textView.selectedRanges
        }
    }

    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        view.delegate = context.coordinator
        view.backgroundColor = .textBackgroundColor
        view.isRichText = false
        view.font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        view.autoresizingMask = [.width, .height]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func updateNSView(_ view: NSTextView, context: Context) {
        view.string = text

        guard context.coordinator.selectedRanges.count > 0 else {
            return
        }

        view.selectedRanges = context.coordinator.selectedRanges
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
