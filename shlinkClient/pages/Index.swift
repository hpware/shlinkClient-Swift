import SwiftUI
import SwiftData

struct IndexPage: View {
    //enum Field: Hashable {
    //    case longLink
    //    case slug
    //    case startDate
    //    case endDate
    //}
    @State private var link = ""
    //@FocusState private var FeildFocus = Field?
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Create a link")) {
                    VStack {
                        TextField(
                            "The link you want to shorten", 
                            text: $link
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit(submitLink)
                        Button(action: submitLink) {
                            Image(systemName: "link.badge.plus")
                        }
                    }
                }
            }.navigationTitle("Shlink")
        }
    }
    private func submitLink() {}
}
