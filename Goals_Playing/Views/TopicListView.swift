import SwiftData
import SwiftUI

struct TopicListView: View
{
    @Query(sort: \Topic.name) private var topics: [Topic]
    @State private var isPresentingEntry = false

    private var existingNames: Set<String>
    {
        Set(topics.map
        {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        })
    }

    var body: some View
    {
        // Check if you really need this Group structure here!!!
        Group
        {
            if topics.isEmpty
            {
                ContentUnavailableView(
                    "No Topics Yet",
                    systemImage: "list.bullet.clipboard",
                    description: Text("Tap + to create your first study topic.")
                )
            }
            else
            {
                List(topics)
                { topic in
                    NavigationLink(value: TopicRoute(topicID: topic.id, topicName: topic.name))
                    {
                        HStack
                        {
                            Text(topic.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Topics")
        .toolbar
        {
            ToolbarItem(placement: .topBarTrailing)
            {
                Button
                {
                    isPresentingEntry = true
                }
                label:
                {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add Topic")
            }
        }
        .sheet(isPresented: $isPresentingEntry)
        {
            NavigationStack
            {
                TopicEntryView(existingNames: existingNames)
                    .navigationTitle("New Topic")
            }
        }
        .navigationDestination(for: TopicRoute.self)
        { route in
            TopicDetailView(topicID: route.topicID,
                            topicName: route.topicName)
        }
    }
}

private struct TopicRoute: Hashable
{
    let topicID: UUID
    let topicName: String
}

#Preview
{
    NavigationStack
    {
        TopicListView()
            .sampleDataContainer()
        
    }
}
