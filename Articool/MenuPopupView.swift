import Foundation
import SwiftUI

struct MenuPopupView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var words: Dict
    @State private var searchWord: String = ""
    
    var popover: NSPopover?
    
    var body: some View {
        VStack {
            TextField("Search word", text: $searchWord)
                .frame(width: 200)
            Spacer()
                .fixedSize()
                .frame(height: 12)
            HStack {
                LookupResultView(searchWord: $searchWord, fontSizeArticle: 18, fontSizeWord: 16, resultSpacing: 8)
                Spacer()
            }
        }
        .background(GeometryReader { geometry in
            Color.clear.preference(key: ViewSizeKey.self, value: geometry.size)
        })
        .padding()
        .fixedSize()
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 53 { // 53 is ESC
                    dismissView()
                    return nil
                }
                return event
            }
        }
    }
    
    private func dismissView() {
        popover?.performClose(nil)
    }
}
                    
struct ViewSizeKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    MenuPopupView()
}
