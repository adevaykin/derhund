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

