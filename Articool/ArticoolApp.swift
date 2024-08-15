import SwiftUI

let url_donate = "https://paypal.me/adevaikin"

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
                    appDelegate.showAboutWindow()
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
