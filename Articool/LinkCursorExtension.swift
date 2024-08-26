import SwiftUI

extension Link {
    func pointingHandCursor() -> some View {
        #if os(macOS)
        self.onHover { inside in
            if inside {
                NSCursor.pointingHand.set()
            } else {
                NSCursor.arrow.set()
            }
        }
        #else
        self
        #endif
    }
}
