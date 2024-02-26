//
//  SplashView.swift
//  Hydra
//
//  Created by starz on 26/02/2024.
//

import SwiftUI

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
