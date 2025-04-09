import SwiftUI

struct ViewAnalytics: View {
    var body: some View {
        NavigationStack {
            Section {
                HStack {
                    Spacer()
                    statCard(title: "Visits", value: "3333")
                    Spacer()
                    statCard(title: "Orphan Visits", value: "3933")
                    Spacer()
                    statCard(title: "Link", value: "3")
                    Spacer()
                    statCard(title: "Tags", value: "0")
                    Spacer()
                }
            }
            List {}
                .navigationTitle("Analytics")
        }
    }
}

struct statCard: View {
    let title: String
    let value: String
    var body: some View {
        VStack {
            Text(title)
            Text(value).font(.caption)
        }
        .padding(.all, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.3))
        )
        .cornerRadius(10)
    }
}
