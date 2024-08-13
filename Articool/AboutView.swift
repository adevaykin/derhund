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
                Image(.dogPath)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .opacity(0.5)
                Spacer()
                    .frame(height: 40)
                    .fixedSize()
                Text("Created by")
                Text("Alexander Devaikin")
                    .bold()
                    Link("alex.devaykin@mail.com", destination: URL(string: "mailto:alex.devaykin@gmail.com")!)
                        .pointingHandCursor()
                Spacer()
                    .frame(height: 20)
                    .fixedSize()
                HStack(spacing: 2) {
                    Text("Donate a coffee:")
                    Link("PayPal",
                         destination: URL(string: "https://paypal.me/adevaikin")!)
                        .pointingHandCursor()
                }
                HStack(spacing: 2) {
                    Text("Source code:")
                    Link("GitHub",
                         destination: URL(string: "https://github.com/adevaykin/derhund")!)
                    .pointingHandCursor()
                }
            }
            .padding()
        }
        .frame(minWidth: 300, minHeight: 500)
    }
}

#Preview {
    AboutView()
}
