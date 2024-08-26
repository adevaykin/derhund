import SwiftUI
import CoreSpotlight

struct ContentViewiOS: View {
    @EnvironmentObject var words: Dict
    @Environment(\.openURL) var openLink
    @State private var showingIndexConfirmation = false
    @State private var showindProgressView = false
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    @FocusState private var isSearchWordFieldFocused: Bool
    
    var body: some View {
//        NavigationStack {
//            Text("")
//                .navigationTitle("Der Hund")
//                .toolbar {
//                    Picker("", selection: $selectedLanguage) {
//                        Text("German").tag(Dictionary.german)
//                    }
//                    .help("Selected language")
//                        .frame(width: 150)
//                    Button("Index", systemImage: "magnifyingglass", action: { showingIndexConfirmation = true })
//                        .labelStyle(.titleAndIcon)
//                        .help("Import dictionary to Spotlight search")
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
//                        .opacity(showindProgressView ? 1 : 0)
//                    Spacer()
//                }
//                .confirmationDialog("Spotlight Index", isPresented: $showingIndexConfirmation) {
//                    Button("Index") { indexDictionary() }
//                    Button("Cancel", role: .cancel) { }
//                } message: {
//                    Text("Adding dictionary to Spotlight may take a few minutes. Should I start?")
//                }
//        }
        VStack {
            Spacer()
            LookupResultView(searchWord: $searchWord)
                .environmentObject(self.words)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onAppear {
                    isSearchWordFieldFocused = true
                }
            TextField("Search word", text: $searchWord)
                .focused($isSearchWordFieldFocused)
                .padding()
            
            
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

#Preview {
    ContentViewiOS()
}
