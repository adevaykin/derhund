import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            VStack {
                Text("About")
                    .font(.title2)
                Text("Der Hund")
                    .font(.title)
                Spacer()
                    .frame(minHeight: 24, idealHeight: 24, maxHeight: 24)
                    .fixedSize()
                Text("Brought to you by")
                Text("Alexander Devaikin")
                    .bold()
                    Link("alex.devaykin@mail.com", destination: URL(string: "mailto:alex.devaykin@gmail.com")!)
                Spacer()
                HStack {
                    Text("Donate me a coffee:")
                    Link("PayPal",
                         destination: URL(string: "https://paypal.me/adevaikin")!)
                }
                HStack {
                    Text("Source code:")
                    Link("GitHub",
                         destination: URL(string: "https://github.com/adevaykin/derhund")!)
                }
            }
            .padding()
        }
        .frame(minWidth: 300, minHeight: 200)
    }
}

#Preview {
    AboutView()
}
