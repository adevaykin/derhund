import Foundation

struct Dict {
    var words = [String : String]()
    
    mutating func addWords(words: [String], article: String) {
        let dictionary = words.map { ($0, article) }
        self.words.merge(dictionary) { (current, _) in current }
    }
    
    mutating func finalize() {
        self.words.removeValue(forKey: "")
    }
}
