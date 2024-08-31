import Foundation
import CoreSpotlight

struct DictEntry {
    var word: String
    var language: String
    var article: String
}

func addWordsToSearchable(words: [DictEntry]) -> [CSSearchableItem] {
    var searchableItems: [CSSearchableItem] = []
    var i = 0
    let myType = UTType(filenameExtension: prefix)!
    let longestWordLength = words.max(by: { $0.word.count < $1.word.count })!.word.count
    for word in words {
        let capitalised = word.word.capitalized
        let attributeSet = CSSearchableItemAttributeSet(contentType: myType)
        attributeSet.identifier = word.language + "." + word.article + "." + word.word
        attributeSet.contentType = documentType
        #if os(macOS)
        attributeSet.title = prefix + " " + capitalised + " " + word.article
        attributeSet.displayName = word.article
        attributeSet.contentDescription = capitalised
        attributeSet.keywords = [ prefix, capitalised ]
        attributeSet.comment = prefix + " " + word.article + " " + capitalised
        #endif
        #if os(iOS)
        attributeSet.displayName = capitalised
        attributeSet.title = capitalised
        attributeSet.contentDescription = word.article
        attributeSet.keywords = [ capitalised ]
        attributeSet.comment = capitalised
        attributeSet.rankingHint = (longestWordLength - capitalised.count) as NSNumber
        #endif

        let id = word.language + "." + word.article + "." + capitalised
        let indexItem = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: documentType, attributeSet: attributeSet)
        searchableItems.append(indexItem)
        
        i += 1
    }
        
    return searchableItems
}
