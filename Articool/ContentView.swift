import SwiftUI
import CoreSpotlight

let prefix = "hund"
let documentType = "de.devaikin.derhund.item"

enum Dictionary: String, CaseIterable, Identifiable {
    case german
    var id: Self { self }
}

struct ContentView: View {
    @EnvironmentObject var words: Dict
    @Environment(\.openURL) var openLink
    @State private var showingIndexConfirmation = false
    @State private var showindProgressView = false
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    @FocusState private var isSearchWordFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Text("")
                .navigationTitle("Welcome")
                .toolbar {
                    Picker("", selection: $selectedLanguage) {
                        Text("German").tag(Dictionary.german)
                    }
                    .help("Selected language")
                        .frame(width: 150)
                    Button("Index", systemImage: "magnifyingglass", action: { showingIndexConfirmation = true })
                        .labelStyle(.titleAndIcon)
                        .help("Import dictionary to Spotlight search")
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                        .opacity(showindProgressView ? 1 : 0)
                    Spacer()
//                    Button("Donate", systemImage: "cup.and.saucer", action: {
//                        openLink(URL(string: url_donate)!)
//                    })
//                    .help("Donate a coffee")
//                    .labelStyle(.iconOnly)
                }
                .confirmationDialog("Spotlight Index", isPresented: $showingIndexConfirmation) {
                    Button("Index") { indexDictionary() }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Adding dictionary to Spotlight may take a few minutes. Should I start?")
                }
        }
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                TextField("Search word", text: $searchWord)
                    .frame(width: 200)
                    .focused($isSearchWordFieldFocused)
                Spacer()
                    .frame(minHeight: 32, maxHeight: 64)
                    .fixedSize()
                Text("Type a word in field above")
                    .opacity(0.4)
                Text("or")
                    .opacity(0.4)
                Text("1. Click Index to add language to Spotlight")
                    .opacity(0.4)
                Text("2. Type 'hund Wort' in Spotlight")
                    .opacity(0.4)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            VStack(alignment: .leading, spacing: 6) {
                if searchWord.isEmpty {
                    Text("der")
                        .font(.system(size: 32.0))
                        .bold()
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                    Text("Hund")
                        .font(.system(size: 24.0))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                } else {
                    ForEach(words.words[searchWord.lowercased()] ?? ["..."], id: \.self) { article in
                        Text(article)
                            .font(.system(size: 32.0))
                            .bold()
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        Text(searchWord.capitalized)
                            .font(.system(size: 24.0))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: true)
                        Spacer()
                            .frame(height: 24)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .onAppear {
                isSearchWordFieldFocused = true
            }
        }
    }
    
    func indexDictionary() {
        showindProgressView = true
        
        var allWords: [DictEntry] = []
        for word in words.words {
            for article in word.value {
                allWords.append(DictEntry(word: word.key, language: "de", article: article ))
            }
        }
        
        allWords.sort { $0.word.count < $1.word.count }
        
        let searchableItems = addWordsToSearchable(words: allWords)
        let clientData = Data()
        let defaultIndex = CSSearchableIndex(name: "Der Hund")
        defaultIndex.deleteAllSearchableItems()
        
        let chunkSize = 20000
        let totalChunks = (searchableItems.count + chunkSize - 1) / chunkSize
        for chunkIndex in 0..<totalChunks {
            let start = chunkIndex * chunkSize
            let end = min(start + chunkSize, searchableItems.count)
            let slice = Array(searchableItems[start..<end])
            
            defaultIndex.beginBatch()
            defaultIndex.indexSearchableItems(slice)
            defaultIndex.endBatch(withClientState: clientData) { error in
                if error != nil {
                    print("Indexing error")
                    print(error?.localizedDescription ?? "Unknown error")
                    showindProgressView = false
                } else {
                    showindProgressView = false
                }
            }
        }
    }
}

struct DictEntry {
    var word: String
    var language: String
    var article: String
}

func addWordsToSearchable(words: [DictEntry]) -> [CSSearchableItem] {
    var searchableItems: [CSSearchableItem] = []
    var i = 0
    let myType = UTType(filenameExtension: prefix)!
    for word in words {
        let attributeSet = CSSearchableItemAttributeSet(contentType: myType)
        let capitalised = word.word.capitalized
        attributeSet.title = prefix + " " + capitalised + " " + word.article
        attributeSet.displayName = word.article
        attributeSet.contentDescription = capitalised
        attributeSet.keywords = [ prefix, capitalised ]
        attributeSet.comment = prefix + " " + word.article + " " + capitalised
        attributeSet.contentType = documentType

        let id = word.language + "." + word.article + "." + capitalised
        let indexItem = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: prefix, attributeSet: attributeSet)
        searchableItems.append(indexItem)
        
        i += 1
    }
        
    return searchableItems
}

#Preview {
    ContentView()
}
