import Foundation
import SwiftData
import SwiftUI

struct IndexPage: View {
    enum BaseField: Hashable {
        case longLink
        case slug
        case tags
    }
    
    @State private var link = ""
    @State private var customizeSlug = ""
    // New links and stuff
    @State private var newLinkTags: [String] = []
    @State private var currentTag: String = ""
    @Query private var storedLinks: [MLinkModel]
    @FocusState private var focusedField: BaseField?
    
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
                        .onSubmit {
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
                            .onSubmit {
                                focusedField = .tags
                            }
                            Spacer()
                            TextField(
                                "Add Tags",
                                text: $currentTag
                            )
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($focusedField, equals: .tags)
                            .submitLabel(.done)
                            .onSubmit {
                                addTag()
                            }
                        }.padding(.bottom, 8)
                        HStack {
                            ForEach(newLinkTags, id: \.self) {
                                tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                        .font(.footnote)
                                    Button(action: removeTag) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .font(.footnote)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        Button(action: submitLink) {
                            HStack {
                                Image(systemName: "link.badge.plus")
                                Text("Create")
                            }
                        }.padding(.vertical, 4)
                            .foregroundColor(.green)
                            .tint(.green)
                    }
                }
                .listRowSeparator(.hidden)
                VStack {
                    ForEach(storedLinks) {
                        i in
                        NavigationLink(destination: getMoreInfo(linkId: "e")) {
                            VStack(alignment: .leading) {
                                Text(i.shortURL).font(.headline)
                            }
                        }.swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                disableLink()
                            } label: {
                                Text("Disable")
                            }
                        }
                    }
                }
            }.navigationTitle("Shlink")
        }.refreshable {
            await refreshLinks()
        }
        /**.dismissKeyboardTap()*/
    }

    private func submitLink() {}

    private func disableLink() {}

    private func addTag() {
        let tag = currentTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tag.isEmpty && !newLinkTags.contains(tag) {
            newLinkTags.append(tag)
            currentTag = ""
        }
    }

    private func removeTag() {}

    private func refreshLinks() {}
}
