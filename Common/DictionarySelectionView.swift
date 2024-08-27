import Foundation
import SwiftUI

enum Dictionary: String, CaseIterable, Identifiable {
    case german
    var id: Self { self }
}

struct DictionarySelectionView: View {
    @Binding var selectedLanguage: Dictionary
    
    var body: some View {
        Picker("", selection: $selectedLanguage) {
            Text("German").tag(Dictionary.german)
        }
        .help("Selected language")
        .frame(width: 150)
    }
}

