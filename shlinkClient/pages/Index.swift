import SwiftUI
import SwiftData
import Foundation



struct IndexPage: View {
    //enum Field: Hashable {
    //    case longLink
    //    case slug
    //    case startDate
    //    case endDate
    //}
    @State private var link = ""
    @State private var customizeSlug = ""
    @Query private var storedLinks: [MLinkModel]
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
                        Spacer()
                        HStack {
                            TextField(
                            "Customize Slug",
                            text: $customizeSlug
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit(submitLink)
                        Spacer()
                        }
                        Button(action: submitLink) {
                            Image(systemName: "link.badge.plus")
                        }
                }}
                VStack {
                    ForEach(storedLinks) {
                        i in 
                        VStack(alignment: .leading) {
                            Text(i.shortURL).font(.headline)
                        }
                    }
                }
            }.navigationTitle("Shlink")
        }
    }
    private func submitLink() {}
}
 
