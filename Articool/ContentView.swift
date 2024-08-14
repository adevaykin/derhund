import SwiftUI
import CoreSpotlight

let prefix = "hund"
let documentType = "de.devaikin.derhund.item"

enum Dictionary: String, CaseIterable, Identifiable {
    case german
    var id: Self { self }
}

struct ContentView: View {
    @State private var showingIndexConfirmation = false
    @State private var showindProgressView = false
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    private var words: Dict
    
    init() {
        words = Dict()
        let all_words = readFromFile(filePath: "german_nouns")!
        for line in all_words {
            if line.isEmpty {
                continue
            }
            let components = line.components(separatedBy: ",")
            words.addWord(word: components[0].lowercased(), article: components[1])
        }

        words.finalize()
    }
    
    var body: some View {
        NavigationStack {
            Text("")
                .navigationTitle("Welcome")
                .toolbar {
                    Picker("", selection: $selectedLanguage) {
                        Text("German").tag(Dictionary.german)
                    }
                        .frame(width: 150)
                    Button("Index", systemImage: "magnifyingglass", action: { showingIndexConfirmation = true })
                        .labelStyle(.titleAndIcon)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                        .opacity(showindProgressView ? 1 : 0)
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
                Text(searchWord.isEmpty ? "der" : words.words[searchWord.lowercased()] ?? "...")
                    .font(.system(size: 32.0))
                    .bold()
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
                Text(searchWord.isEmpty ? "Hund" : searchWord.capitalized)
                    .font(.system(size: 24.0))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
    
    
    func indexDictionary() {
        showindProgressView = true
        
        var allWords: [DictEntry] = []
        for word in words.words {
            allWords.append(DictEntry(word: word.key, language: "de", article: word.value ))
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

func readFromFile(filePath: String) -> [String]? {
    let fullPath = Bundle.main.path(forResource: filePath, ofType: "txt")!
    
    do {
        let content = try String(contentsOfFile: fullPath, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        return lines
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

func addWordsToSearchable(words: [DictEntry]) -> [CSSearchableItem] {
    var searchableItems: [CSSearchableItem] = []
    var i = 0
    let myType = UTType(filenameExtension: prefix)!
    for word in words {
        let attributeSet = CSSearchableItemAttributeSet(contentType: myType)
        let capitalised = word.word.capitalized
        attributeSet.title = word.article + " " + capitalised + "." + prefix
        attributeSet.contentDescription = capitalised
        attributeSet.displayName = word.article
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
