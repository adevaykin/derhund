import SwiftUI

@main
struct ArticoolApp: App {
    @NSApplicationDelegateAdaptor(DerHundAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutPanel()
                }) {
                    Text("About Det Hund")
                }
            };
            CommandGroup(replacing: .newItem, addition: { })
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
    }
}
