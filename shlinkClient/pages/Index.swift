import SwiftUI
import SwiftData
import Foundation



struct IndexPage: View {
    enum Field: Hashable {
        case longLink
        case slug
        case title
        case startDate
        case endDate
    }
    @State private var link = ""
    @State private var customizeSlug = ""
    @State private var newLinkTitle = ""
    @Query private var storedLinks: [MLinkModel]
    @FocusState private var focusedField: Field?

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
                        .focused($focusedField, equals: .longLink)
                        .submitLabel(.next)
                        .onSubmit{
                            focusedField = .slug
                        }
                        .padding(.vertical, 8)
                        Spacer()
                        HStack {
                            TextField(
                            "Customize Slug",
                            text: $customizeSlug
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .slug)
                        .onSubmit{
                            focusedField = .title
                        }
                        Spacer()
                            TextField(
                                "Title",
                                text: $newLinkTitle
                            )
                            .focused($focusedField, equals: . title)
                            .onSubmit(submitLink)
                        }.padding(.bottom, 8)
                        Button(action: submitLink) {
                            HStack {
                                Image(systemName: "link.badge.plus")
                                Text("Create")
                            }
                        }.padding(.vertical, 4)
                        
                }
                }
                .listRowSeparator(.hidden)
                VStack {
                    ForEach(storedLinks) {
                        i in 
                        NavigationLink(destination: getMoreInfo(i.id)) {
                            VStack(alignment: .leading) {
                            Text(i.shortURL).font(.headline)
                        }
                        }
                    }
                }
            }.navigationTitle("Shlink")
        }
    }
    private func submitLink() {}
}
 
