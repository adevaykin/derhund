import Foundation
import SwiftUI

struct LookupResultView: View {
    @Binding var searchWord: String
    @EnvironmentObject var words: Dict
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if searchWord.isEmpty {
                Text("der")
                    .font(.system(size: fontSizeArticle))
                    .bold()
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
                Text("Hund")
                    .font(.system(size: fontSizeWord))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
                Link("\(Image(systemName: "globe")) Wiktionary",
                     destination: URL(string: wiktionaryUrl + "Hund" + "#Substantiv,_m")!)
                    .pointingHandCursor()
                    .help("Lookup \"der Hund\" on wiktionary.com")

            } else {
                ForEach(words.words[searchWord.lowercased()] ?? ["..."], id: \.self) { article in
                    Text(article)
                        .font(.system(size: fontSizeArticle))
                        .bold()
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                    Text(searchWord.capitalized)
                        .font(.system(size: fontSizeWord))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                    let gender = articleToGenderPostfix(article: article)
                    Link("\(Image(systemName: "globe")) Wiktionary",
                         destination: URL(string: wiktionaryUrl + searchWord.capitalized + "#Substantiv,_" + gender)!)
                        .pointingHandCursor()
                        .help("Lookup \"" + article + " " + searchWord.capitalized + "\" on wiktionary.com")
                    Spacer()
                        .frame(height: 24)
                }
            }
            #if os(macOS)
            Spacer()
            #endif
        }
    }
    
    private func articleToGenderPostfix(article: String) -> String {
        switch article {
        case "der":
            return "m"
        case "die":
            return "f"
        case "das":
            return "n"
        default:
            return "n"
        }
    }
}
