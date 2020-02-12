//
//  TooltipView.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import SwiftUI

extension View {
    func toolTip(_ toolTip: String) -> some View {
        self.overlay(TooltipView(toolTip))
    }
}

private struct TooltipView: NSViewRepresentable {
    let toolTip: String

    init(_ toolTip: String?) {
        if let toolTip = toolTip {
            self.toolTip = toolTip
        }
        else
        {
            self.toolTip = ""
        }
    }

    func makeNSView(context: NSViewRepresentableContext<TooltipView>) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<TooltipView>) {
        nsView.toolTip = self.toolTip
    }
}
