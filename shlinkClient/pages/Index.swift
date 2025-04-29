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
    @State private var more = false
    // New links and stuff
    @State private var newLinkTags: [String] = []
    @State private var currentTag: String = ""
    @State private var slugLength = 0
    @State private var maxVisits = 0
    @State private var linkTitle = ""
    @State private var enabledFrom = Date()
    @State private var enabledUntil = Date()
    @Query private var storedLinks: [MLinkModel]
    @FocusState private var focusedField: BaseField?

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Create a link")) {
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
                    HStack {
                        TextField(
                            "Customize Slug",
                            text: $customizeSlug
                        )
                        .disabled(
                            slugLength > 0
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
                        .submitLabel(.next)
                        .onSubmit(addTag)

                    }.padding(.bottom, 4)
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
                            .padding(.horizontal, 4)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }.padding(.vertical, 3)
                    Spacer()
                    if more == true {
                        // MAIN INPUT
                        VStack {
                            TextField(
                                "Link Title",
                                text: $linkTitle
                            )
                            HStack {
                                Text("Max Visits")
                                TextField("", value: $maxVisits, formatter: NumberFormatter())
                                Stepper(
                                    "",
                                    value: $maxVisits
                                )
                                HStack {
                                    Text("Slug Length")
                                    TextField("", value: $slugLength, formatter: NumberFormatter())
                                    Stepper(
                                        "",
                                        value: $slugLength,
                                        in: 4 ... 255 // over 255 the web browser WILL crash, and you won't be able to delete it.
                                    )
                                    .disabled(customizeSlug != "")
                                }
                            }.padding(.vertical, 2)
                            VStack {
                                // Use datepicker for the iOS picking date thingy.
                                HStack {
                                    DatePicker(
                                        "Enabled Since",
                                        selection: $enabledFrom,
                                        /*!
                                            * .date for date
                                            * .hourAndMinute for hour and minute duhh
                                            * .hourMinuteAndSecond for I guess setting a clock app?
                                            */
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                }
                                Spacer()
                                HStack {
                                    DatePicker(
                                        "Enabled Until",
                                        selection: $enabledUntil,
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                }
                            }

                            // HIDE
                            HStack(spacing: 4) {
                                Button(action: {
                                    more = false
                                }) {
                                    HStack {
                                        Image(systemName: "chevron.up")
                                            .font(.footnote)
                                        Text("Hide")
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } else {
                        HStack(spacing: 4) {
                            Button(action: {
                                more = true
                            }) {
                                HStack {
                                    Image(systemName: "chevron.down")
                                        .font(.footnote)
                                    Text("More options")
                                }
                            }
                            .buttonStyle(.plain)
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
    }

    private func submitLink() {
        Task {
            let result = try? await createNewLink(
                long: link,
                slug: !customizeSlug.isEmpty ? customizeSlug : "",
                crawlable: false,
                forwardParam: false,
                useExisting: false
            )

            // Reset form if successful
            if result != nil {
                link = ""
                customizeSlug = ""
                newLinkTags = []
                more = false
                await refreshLinks()
            }
        }
    }

    private func disableLink() {}

    private func addTag() {
        let tag = currentTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tag.isEmpty, !newLinkTags.contains(tag) {
            newLinkTags.append(tag)
            currentTag = ""
        }
    }

    private func removeTag() {}

    private func refreshLinks() {}
}
