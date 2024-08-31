import SwiftUI
import CoreSpotlight

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var words: Dict
    @Environment(\.openURL) var openLink
    
    @State private var showingIndexConfirmation = false
    @State private var showingIndexEndedConfirmation = false
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    @State private var indexBatchesInFlight = 0
    
    @FocusState private var isSearchWordFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Text("")
                .navigationTitle("Der Hund")
                .toolbar {
                    DictionarySelectionView(selectedLanguage: $selectedLanguage)
                    Button("\(Image(systemName: "arrow.clockwise")) Index", systemImage: "magnifyingglass", action: { showingIndexConfirmation = true })
                        .labelStyle(.titleOnly)
                        .help("Import dictionary to Spotlight search")
                }
                .confirmationDialog("Spotlight Index", isPresented: $showingIndexConfirmation) {
                    Button("Index") { indexDictionary() }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Adding dictionary to Spotlight may take a few minutes. Should I start?")
                }
                .confirmationDialog("Index Done", isPresented: $showingIndexEndedConfirmation) {
                    Button("Ok", role: .cancel) { }
                } message: {
                        Text("Dictionary successfully published to Spotlight. It may take a few minutes more before results will start to appear in Spotlight search. Simply search for any German word.")
                }
        }
        VStack {
            VStack(spacing: 12) {
                Text("Updating Spotlight index.")
                    .foregroundColor(.secondary)
                Text("Keep app open.")
                    .foregroundColor(.secondary)
                Text(String(format: "%d items left", indexBatchesInFlight))
                    .foregroundColor(.secondary)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .opacity(indexBatchesInFlight > 0 ? 1 : 0)
            
            Spacer()
            LookupResultView(searchWord: $searchWord, fontSizeArticle: 22, fontSizeWord: 16, resultSpacing: 12)
                .environmentObject(self.words)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onAppear {
                    isSearchWordFieldFocused = true
                }
            TextField("Search word", text: $searchWord)
                .focused($isSearchWordFieldFocused)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
        }
        .padding()
    }
    
    func indexDictionary() {
        var allWords: [DictEntry] = []
        for word in words.words {
            for article in word.value {
                allWords.append(DictEntry(word: word.key, language: "de", article: article ))
            }
        }
        
        allWords.sort { $0.word.count < $1.word.count }
        
        let searchableItems = addWordsToSearchable(words: allWords)
        let clientData = Data()
        let defaultIndex = CSSearchableIndex(name: documentType)
        defaultIndex.deleteAllSearchableItems()
        
        let chunkSize = 1024
        let totalChunks = (searchableItems.count + chunkSize - 1) / chunkSize
        indexBatchesInFlight = totalChunks-1
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
                }
                
                indexBatchesInFlight -= 1
                if (indexBatchesInFlight == 0) {
                    showingIndexEndedConfirmation = true
                }
            }
        }
    }
}

func accentColor(for colorScheme: ColorScheme) -> Color {
    switch colorScheme {
        case .dark:
            return Color(red: 0.1, green: 0.1, blue: 0.1)
        case .light:
            return Color(red: 0.8, green: 0.8, blue: 0.8)
        @unknown default:
            return Color.blue
        }
}

#Preview {
    ContentView()
}
