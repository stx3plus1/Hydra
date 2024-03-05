//
//  PopupView.swift
//  Hydra
//
//  Created by ~~starz~~ on 26/02/2024.
//

// thank you so much
// https://stackoverflow.com/questions/70091919/how-set-position-of-window-on-the-desktop-in-swiftui
// i may have done some COMMAND+C then COMMAND+V since i am a literal idiot
// i owe it to pd95 man

import SwiftUI
import Combine

let screenSize = NSScreen.main?.visibleFrame.size
let screenWidth = screenSize!.width
let screenHeight = screenSize!.height

let WINDOWWIDTH: CGFloat = 300
let WINDOWHEIGHT: CGFloat = 125

struct WindowAccessor: NSViewRepresentable {
    let onChange: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        context.coordinator.monitorView(view)
        return view
    }

    func updateNSView(_ view: NSView, context: Context) {
    }

    func makeCoordinator() -> WindowMonitor {
        WindowMonitor(onChange)
    }

    class WindowMonitor: NSObject {
        private var cancellables = Set<AnyCancellable>()
        private var onChange: (NSWindow?) -> Void

        init(_ onChange: @escaping (NSWindow?) -> Void) {
            self.onChange = onChange
        }
        
        func monitorView(_ view: NSView) {
            view.publisher(for: \.window)
                .removeDuplicates()
                .dropFirst()
                .sink { [weak self] newWindow in
                    guard let self = self else { return }
                    self.onChange(newWindow)
                    if let newWindow = newWindow {
                        self.monitorClosing(of: newWindow)
                    }
                }
                .store(in: &cancellables)
        }

        private func monitorClosing(of window: NSWindow) {
            NotificationCenter.default
                .publisher(for: NSWindow.willCloseNotification, object: window)
                .sink { [weak self] notification in
                    guard let self = self else { return }
                    self.onChange(nil)
                    self.cancellables.removeAll()
                }
                .store(in: &cancellables)
        }
    }
}

class AppWindow: NSWindow {
    init() {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 480, height: 300), styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView], backing: .buffered, defer: false)
        makeKeyAndOrderFront(nil)
        isReleasedWhenClosed = false
        styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        title = "Hydra"
        contentView = NSHostingView(rootView: HydraWindow())
    }
}

struct HydraWindow: View {
    @Environment(\.openURL) var openURL
    @State var window : NSWindow?
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            Text("Cut off a head, two more will take its place.")
                .padding()
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { newValue in
                    if let url = URL(string: "hydra://hydrawindow") {
                        openURL(url)
                    }
                }
        }
        .frame(width: WINDOWWIDTH, height: WINDOWHEIGHT, alignment: .center)
        .background(WindowAccessor { newWindow in
            if let newWindow = newWindow {
                monitorVisibility(window: newWindow)

            } else {
                // window closed: release all references
                self.window = nil
                self.cancellables.removeAll()
            }
        })
    }

    private func monitorVisibility(window: NSWindow) {
        window.publisher(for: \.isVisible)
            .dropFirst()  // we know: the first value is not interesting
            .sink(receiveValue: { isVisible in
                if isVisible {
                    self.window = window
                    placeWindow(window)
                }
            })
            .store(in: &cancellables)
    }

    private func placeWindow(_ window: NSWindow) {
        let main = NSScreen.main!
        let visibleFrame = main.visibleFrame
        let windowSize = window.frame.size

        let windowX = visibleFrame.midX - windowSize.width/2
        let windowY = visibleFrame.midY - windowSize.height/2
        
        let windowAddX = CGFloat.random(in: CGFloat(-screenWidth)/2..<screenWidth/2)
        let windowAddY = CGFloat.random(in: CGFloat(-screenHeight)/2..<screenHeight/2)

        let desiredOrigin = CGPoint(x: windowX+windowAddX, y: windowY+windowAddY)
        window.setFrameOrigin(desiredOrigin)
    }
}
