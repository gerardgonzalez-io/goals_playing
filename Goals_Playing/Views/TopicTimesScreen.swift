import SwiftData
import SwiftUI

struct TopicTimesScreen: View
{
    @Query private var allSessions: [StudySession]

    let topicID: UUID
    let topicName: String

    private var topicSessions: [StudySession]
    {
        allSessions.filter { $0.topicID == topicID }
    }

    private var dailyTime: TimeInterval
    {
        TimeCalculator.dailyTime(from: topicSessions)
    }

    private var totalTime: TimeInterval
    {
        TimeCalculator.totalTime(from: topicSessions)
    }

    var body: some View
    {
        VStack(spacing: 16)
        {
            timeCard(
                title: "Daily Time",
                symbol: "calendar",
                time: dailyTime,
                description: "Time studied today in this topic."
            )

            timeCard(
                title: "Total Time",
                symbol: "clock.fill",
                time: totalTime,
                description: "Total accumulated time for this topic."
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Times")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func timeCard(title: String, symbol: String, time: TimeInterval, description: String) -> some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            HStack
            {
                Label(title, systemImage: symbol)
                    .font(.headline)
                Spacer()
            }

            Text(formatted(time: time))
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .monospacedDigit()

            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func formatted(time: TimeInterval) -> String
    {
        let value = Int(time)
        let hours = value / 3_600
        let minutes = (value % 3_600) / 60
        let seconds = value % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview
{
    NavigationStack {
        TopicTimesScreen(topicID: UUID(), topicName: "Mathematics")
    }
    .modelContainer(for: [StudySession.self], inMemory: true)
}
