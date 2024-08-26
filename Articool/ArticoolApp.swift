import SwiftUI

@main
struct ArticoolApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(DerHundAppDelegate.self) var appDelegate
    #endif
    @StateObject private var dict = Dict()
    
    #if os(macOS)
    init() {
        appDelegate.dict = dict
    }
    #endif
    
    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            ContentView()
                .environmentObject(dict)
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutWindow()
                }) {
                    Text("About Det Hund")
                }
            };
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        #endif
        #if os(iOS)
        WindowGroup {
            ContentViewiOS()
                .environmentObject(dict)
        }
        #endif
    }
}
