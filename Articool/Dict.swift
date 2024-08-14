import Foundation

struct Dict {
    var words = [String : String]()
    
    mutating func addWord(word: String, article: String) {
        self.words[word] = article;
    }
    
    mutating func finalize() {
        self.words.removeValue(forKey: "")
    }
}
