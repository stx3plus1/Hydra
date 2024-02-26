//
//  HydraApp.swift
//  Hydra
//
//  Created by starz on 25/02/2024.
//

import SwiftUI

@main
struct HydraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension View {
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        return win
    }
}
