import SwiftUI

struct ContentView: View {
    @EnvironmentObject var words: Dict
    @Environment(\.openURL) var openLink
    @State private var showingIndexConfirmation = false
    @State private var showindProgressView = false
    @State private var selectedLanguage: Dictionary = Dictionary.german
    @State private var searchWord: String = ""
    @FocusState private var isSearchWordFieldFocused: Bool
    
    var body: some View {
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
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
