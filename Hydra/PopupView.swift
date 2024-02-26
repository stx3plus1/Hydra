//
//  PopupView.swift
//  Hydra
//
//  Created by starz on 26/02/2024.
//

import SwiftUI

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
