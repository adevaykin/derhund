import SwiftUI
import CoreSpotlight

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var words: Dict
    @Environment(\.openURL) var openLink
    
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    @FocusState private var isSearchWordFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Text("")
                .navigationTitle("Der Hund")
                .toolbar {
                    DictionarySelectionView(selectedLanguage: $selectedLanguage)
                }
        }
        VStack {
            Spacer()
            LookupResultView(searchWord: $searchWord)
                .environmentObject(self.words)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onAppear {
                    isSearchWordFieldFocused = true
                }
            TextField("Search word", text: $searchWord)
                .focused($isSearchWordFieldFocused)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
        }
        .padding()
    }
}

func accentColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(red: 0.1, green: 0.1, blue: 0.1) // Dark mode color
        case .light:
            return Color(red: 0.8, green: 0.8, blue: 0.8) // Light mode color
        @unknown default:
            return Color.blue // Fallback color
        }
    }

#Preview {
    ContentView()
}
