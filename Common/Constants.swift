import Foundation

let prefix = "hund"
let documentType = "de.devaikin.derhund.item"
let wiktionaryUrl = "https://de.wiktionary.org/wiki/"

#if os(macOS)
let fontSizeArticle = 32.0
let fontSizeWord = 24.0
let resultVSpace = 24.0
#endif
#if os(iOS)
let fontSizeArticle = 22.0
let fontSizeWord = 16.0
let resultVSpace = 12.0
#endif
