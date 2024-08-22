import Foundation
import SwiftUI
import AppKit

class DerHundAppDelegate: NSObject, NSApplicationDelegate {
    var dict: Dict?
    
    private var aboutBoxWindowController: NSWindowController?
    private var menuBar: MenuBarIcon?
    private var popover = NSPopover.init()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        let contentView = MenuPopupView().environmentObject(dict!)
//        
//        popover.contentSize = NSSize(width: 75, height: 360)
//        popover.contentViewController = NSHostingController(rootView: contentView)
//        menuBar = MenuBarIcon.init(popover)
    }

    func showAboutWindow() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable,/* .resizable,*/ .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "About Der Hund"
            window.contentView = NSHostingView(rootView: AboutView())
            aboutBoxWindowController = NSWindowController(window: window)
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
}
