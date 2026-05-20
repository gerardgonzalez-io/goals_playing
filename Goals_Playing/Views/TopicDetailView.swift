import SwiftUI

struct TopicDetailView: View
{
    let topicID: UUID
    let topicName: String

    var body: some View
    {
        List
        {
            NavigationLink(value: TopicDetailRoute.timerView)
            {
                topicCard(
                    title: "Timer",
                    subtitle: "Start or continue your study timer for this topic.",
                    symbol: "play.circle.fill"
                )
            }

            NavigationLink(value: TopicDetailRoute.streakView)
            {
                topicCard(
                    title: "Streak",
                    subtitle: "Check your current and longest study streak.",
                    symbol: "flame.fill"
                )
            }

            NavigationLink(value: TopicDetailRoute.timesView)
            {
                topicCard(
                    title: "Times",
                    subtitle: "See daily and total accumulated study time.",
                    symbol: "clock.fill"
                )
            }
        }
        .navigationTitle(topicName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: TopicDetailRoute.self) { route in
            switch route {
            case .timerView:
                TimerScreen(topicID: topicID, topicName: topicName)
            case .streakView:
                TopicStreakScreen(topicName: topicName)
            case .timesView:
                TopicTimesScreen(topicID: topicID, topicName: topicName)
            }
        }
    }

    private func topicCard(title: String, subtitle: String, symbol: String) -> some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4)
            {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

private enum TopicDetailRoute: Hashable
{
    case timerView
    case streakView
    case timesView
}

private struct TopicStreakScreen: View
{
    let topicName: String

    var body: some View
    {
        Text("Streak screen for \(topicName)")
            .navigationTitle("Streak")
    }
}

#Preview
{
    NavigationStack {
        TopicDetailView(topicID: UUID(), topicName: "Mathematics")
    }
}
