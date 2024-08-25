import Foundation
import SwiftUI

struct MenuPopupView: View {
    @EnvironmentObject var words: Dict
    @State private var searchWord: String = ""
    
    var body: some View {
        VStack {
            TextField("Search word", text: $searchWord)
                .frame(width: 200)
//            Text(searchWord.isEmpty ? "der" : words.words[searchWord.lowercased()] ?? "...")
//                .font(.system(size: 32.0))
//                .bold()
//                .lineLimit(1)
//                .fixedSize(horizontal: true, vertical: true)
            Text(searchWord.isEmpty ? "Hund" : searchWord.capitalized)
                .font(.system(size: 24.0))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
        }
        .padding()
    }
}

#Preview {
    MenuPopupView()
}
