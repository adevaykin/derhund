import SwiftUI
import CoreSpotlight

enum Dictionary: String, CaseIterable, Identifiable {
    case german
    var id: Self { self }
}

struct ContentView: View {
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    private var words: Dict
    
    init() {
        words = Dict()
        let words_der = readFromFile(filePath: "substantiv_singular_der")!
        let words_das = readFromFile(filePath: "substantiv_singular_das")!
        let words_die = readFromFile(filePath: "substantiv_singular_die")!
        words.addWords(words: words_der, article: "der")
        words.addWords(words: words_das, article: "das")
        words.addWords(words: words_die, article: "die")
        words.finalize()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                TextField("Search word", text: $searchWord)
                    .frame(width: 200)
                Spacer()
                HStack {
                    Picker("", selection: $selectedLanguage) {
                        Text("German").tag(Dictionary.german)
                    }
                    .frame(width: 150)
                    Button(action: indexDictionary) {
                        Image(systemName:"repeat")
                        Text("Index")
                    }
                }
            }
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
            .padding()
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

func addWordsToSearchable(words: [DictEntry]) -> ([CSSearchableItem], Data) {
    var clientData = Data()
    var searchableItems: [CSSearchableItem] = []
    var i = 0
    let myType = UTType(filenameExtension: "artcl")!
    for word in words.reversed() {
        let attributeSet = CSSearchableItemAttributeSet(contentType: myType)
        attributeSet.title = word.article + " " + word.word + ".artcl"
        attributeSet.contentDescription = word.word
        attributeSet.displayName = word.article
        attributeSet.keywords = [ "artcl", word.word ]
        attributeSet.comment = "artcl " + word.article + " " + word.word
        attributeSet.contentType = "de.devaikin.articool.artcl"

        let id = "artcl." + word.language + "." + word.article + "." + word.word
        let indexItem = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: "artcl", attributeSet: attributeSet)
        searchableItems.append(indexItem)

//        do {
//            //let jsonData = try JSONSerialization.data(withJSONObject: id, options: [])
//            //clientData.append(jsonData)
//        } catch {
//            print("Error serializing unique identifiers: \(error)")
//        }
        
        i += 1
    }
        
    return (searchableItems, clientData)
}

func makeDictEntries(words: [String], article: String) -> [DictEntry] {
    var result: [DictEntry] = []
    
    for word in words {
        let dictEntry = DictEntry(word: word, language: "de", article: article)
        result.append(dictEntry)
    }
    
    return result
}

func indexDictionary() {
    let derWords = makeDictEntries(words: readFromFile(filePath: "substantiv_singular_der")!, article: "der")
    //let dieWords = makeDictEntries(words: readFromFile(filePath: "substantiv_singular_die")!, article: "die")
    //let dasWords = makeDictEntries(words: readFromFile(filePath: "substantiv_singular_das")!, article: "das")
    
    var allWords: [DictEntry] = []
    allWords.append(contentsOf: derWords)
    //allWords.append(contentsOf: dieWords)
    //allWords.append(contentsOf: dasWords)
    
    allWords.sort { $0.word.count < $1.word.count }
    
    let (searchableItems, clientData) = addWordsToSearchable(words: allWords)
    
    let defaultIndex = CSSearchableIndex(name: "Articool")
    print("Clean index")
    defaultIndex.deleteAllSearchableItems()
    
    print("Start indexing")
    defaultIndex.beginBatch()
    
    defaultIndex.indexSearchableItems(searchableItems)
    defaultIndex.endBatch(withClientState: clientData) { error in
        if error != nil {
            print(error?.localizedDescription ?? "Unknown error")
        } else {
            print("Item indexed.")
        }
    }
}

#Preview {
    ContentView()
}
