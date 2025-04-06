import SwiftUI
import SwiftData

struct IndexPage: View {
    @State private var link = ""
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Create a link")) {
                    HStack {
                        TextField(
                            "The link you want to shorten", 
                            text: $link
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit(submitLink)
                        Button(action: submitLink) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }.navigationTitle("Shlink")
        }
    }
    private func submitLink() {}
}
