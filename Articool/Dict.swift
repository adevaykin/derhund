import Foundation

class Dict: ObservableObject {
    @Published var words = [String : String]()
    
    init() {
        let all_words = readFromFile(filePath: "german_nouns")!
        var read_words = [String : String]()
        for line in all_words {
            if line.isEmpty {
                continue
            }
            let components = line.components(separatedBy: ",")
            read_words[components[0].lowercased()] = components[1];
            read_words.removeValue(forKey: "")
        }
        
        self.words = read_words
    }
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
