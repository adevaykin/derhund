import SwiftUI

@main
struct DerHundApp: App {
    @NSApplicationDelegateAdaptor(DerHundAppDelegate.self) var appDelegate
    @StateObject private var dict = Dict()
    
    init() {
        appDelegate.dict = dict
    }
    
    var body: some Scene {
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
    }
}
