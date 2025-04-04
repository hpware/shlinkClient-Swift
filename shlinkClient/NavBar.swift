import SwiftUI

struct CustomTabBarItem: Identifiable {
    var id: String
    var view: AnyView
}

struct Nav: View {
    @State private var activeTab: String = "FirstPage"

    private var tabItems: [CustomTabBarItem] = [
        CustomTabBarItem(id: "FirstPage", view: AnyView(S1())),
        CustomTabBarItem(id: "SecondView", view: AnyView(S2())),
        CustomTabBarItem(id: "Third", view: AnyView(S3())),
        CustomTabBarItem(id: "Fourth", view: AnyView(S4())),
        CustomTabBarItem(id: "Fifth", view: AnyView(S5()))
    ]

    var body: some View {
        CustomTabBar(activeTab: $activeTab, items: tabItems) {
            ForEach(tabItems) { item in
                if item.id == activeTab {
                    item.view
                }
            }
        }
    }
}

struct CustomTabBar<Content: View>: View {
    @Binding var activeTab: String
    var items: [CustomTabBarItem]
    var content: Content

    init(activeTab: Binding<String>, items: [CustomTabBarItem], @ViewBuilder content: () -> Content) {
        self._activeTab = activeTab
        self.items = items
        self.content = content()
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(items) { item in
                    Button(action: {
                        activeTab = item.id
                    }) {
                        Text(item.id)
                    }
                }
            }
            content
        }
    }
}

struct S1: View {
    var body: some View {
        Image(systemName: "macpro.gen1")
            .font(.system(size: 150, weight: .medium, design: .rounded))
    }
}

struct S2: View {
    var body: some View {
        Image(systemName: "macpro.gen2")
            .font(.system(size: 150, weight: .medium, design: .rounded))
    }
}

struct S3: View {
    var body: some View {
        Image(systemName: "macpro.gen3")
            .font(.system(size: 150, weight: .medium, design: .rounded))
    }
}

struct S4: View {
    var body: some View {
        Image(systemName: "globe")
            .font(.system(size: 150, weight: .medium, design: .rounded))
    }
}

struct S5: View {
    var body: some View {
        Image(systemName: "macstudio")
            .font(.system(size: 150, weight: .medium, design: .rounded))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
