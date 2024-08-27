import SwiftUI

@main
struct DerHundApp: App {
    @StateObject private var dict = Dict()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dict)
        }
    }
}
