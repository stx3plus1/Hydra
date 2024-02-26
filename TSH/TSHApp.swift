//
//  HydraApp.swift
//  Hydra
//
//  Created by starz on 25/02/2024.
//

import SwiftUI

@main
struct TSHApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Press the Close button to start, else press CMD + Q now!")
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { newValue in
                    HydraWindow().openInWindow(title: "Hydra", sender: self)
                }
        }
        .frame(width: 475.0, height: 200.0)
    }
}

struct HydraWindow: View {
    var body: some View {
        VStack {
            Text("Cut off a head, two more will take its place.")
                .padding()
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { newValue in
                    HydraWindow().openInWindow(title: "Hydra", sender: self)
                    HydraWindow().openInWindow(title: "Hydra", sender: self)
                }
        }
        .frame(width: 325.0, height: 100.0)
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
