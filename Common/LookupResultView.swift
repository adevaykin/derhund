import Foundation
import SwiftUI
#if os(iOS)
import SafariServices
#endif

struct LookupResultView: View {
    @EnvironmentObject var words: Dict
    @Binding var searchWord: String
    
    @State private var isShowingSafari = false
    @State private var urlToShow: URL?
    
    let fontSizeArticle: CGFloat
    let fontSizeWord: CGFloat
    let resultSpacing: CGFloat
    
    init(searchWord: Binding<String>, fontSizeArticle: Float, fontSizeWord: Float, resultSpacing: Float) {
        self._searchWord = searchWord
        
        self.fontSizeArticle = CGFloat(fontSizeArticle)
        self.fontSizeWord = CGFloat(fontSizeWord)
        self.resultSpacing = CGFloat(resultSpacing)
    }
    
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
                #if os(macOS)
                Link("\(Image(systemName: "globe")) Wiktionary",
                     destination: URL(string: wiktionaryUrl + "Hund" + "#Substantiv,_m")!)
                    .pointingHandCursor()
                    .help("Lookup \"der Hund\" on wiktionary.com")
                #endif
                #if os(iOS)
                Text("\(Image(systemName: "globe")) Wiktionary")
                    .foregroundColor(Color.accentColor)
                    .onTapGesture {
                        urlToShow = URL(string: wiktionaryUrl + "Hund" + "#Substantiv,_m")!
                        isShowingSafari = true
                    }
                    .sheet(isPresented: $isShowingSafari) {
                        if let url = urlToShow {
                            SafariView(url: url)
                        }
                    }
                #endif
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
                    #if os(macOS)
                    Link("\(Image(systemName: "globe")) Wiktionary",
                         destination: URL(string: wiktionaryUrl + searchWord.capitalized + "#Substantiv,_" + gender)!)
                        .pointingHandCursor()
                        .help("Lookup \"" + article + " " + searchWord.capitalized + "\" on wiktionary.com")
                    #endif
                    #if os(iOS)
                    Text("\(Image(systemName: "globe")) Wiktionary")
                        .foregroundColor(Color.accentColor)
                        .onTapGesture {
                            urlToShow = URL(string: wiktionaryUrl + searchWord.capitalized + "#Substantiv,_" + gender)!
                            isShowingSafari = true
                        }
                        .sheet(isPresented: $isShowingSafari) {
                            if let url = urlToShow {
                                SafariView(url: url)
                            }
                        }
                    #endif
                    Spacer()
                        .frame(height: resultSpacing)
                }
            }
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

#if os(iOS)
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
#endif
