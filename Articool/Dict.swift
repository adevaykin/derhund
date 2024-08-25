import Foundation

class Dict: ObservableObject {
    @Published var words = [String : [String]]()
    
    init() {
        let all_words = readFromFile(filePath: "german_nouns")!
        var read_words = [String : [String]]()
        for line in all_words {
            if line.isEmpty {
                continue
            }
            let components = line.components(separatedBy: ",")
            if components.count != 2 || components[0].isEmpty {
                continue
            }
            
            let lowercased = components[0].lowercased()
            if let existing = read_words[lowercased] {
                var duplicate = false
                for article in existing {
                    if article == components[1] {
                        duplicate = true
                    }
                }
                if !duplicate {
                    read_words[lowercased]?.append(components[1])
                }
            } else {
                read_words[lowercased] = [components[1]];
            }
        }
        
        self.words = read_words
        for word in self.words {
            if word.value.count > 1 {
                print(word.key)
                break
            }
        }
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
