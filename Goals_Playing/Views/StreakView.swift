import SwiftData
import SwiftUI

struct StreakView: View
{
    @Query private var allSessions: [StudySession]

    let topicID: UUID
    let topicName: String

    private let streakCalculator = StreakCalculator()

    private var topicSessions: [StudySession]
    {
        allSessions.filter { $0.topicID == topicID }
    }

    private var currentStreak: Int
    {
        streakCalculator.calculateStreak(for: topicSessions)
    }

    var body: some View
    {
        VStack(spacing: 16)
        {
            Text(topicName)
                .font(.headline)
                .foregroundStyle(.secondary)

            streakCard(
                title: "Current Streak",
                symbol: "flame.fill",
                value: currentStreak,
                description: "Consecutive study days up to today or yesterday."
            )

            Spacer()
        }
        .padding()
        .navigationTitle("Streak")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func streakCard(title: String, symbol: String, value: Int, description: String) -> some View
    {
        VStack(alignment: .leading, spacing: 8)
        {
            HStack
            {
                Label(title, systemImage: symbol)
                    .font(.headline)
                Spacer()
            }

            Text("\(value) day\(value == 1 ? "" : "s")")
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

}

#Preview
{
    NavigationStack
    {
        StreakView(topicID: UUID(), topicName: "Mathematics")
            .sampleDataContainer()
    }
}
