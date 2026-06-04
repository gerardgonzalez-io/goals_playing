import SwiftData
import SwiftUI

struct GoalView: View
{
    @Environment(\.modelContext) private var modelContext
    @Query private var allGoals: [Goal]

    let topicID: UUID
    let topicName: String

    @State private var selectedHours = 1

    private var topicGoals: [Goal]
    {
        allGoals
            .filter { $0.topicID == topicID }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View
    {
        VStack(spacing: 16)
        {
            Text(topicName)
                .font(.headline)
                .foregroundStyle(.secondary)

            VStack(spacing: 8)
            {
                Text("Daily Goal")
                    .font(.headline)

                Picker("Hours", selection: $selectedHours)
                {
                    ForEach(1...12, id: \.self)
                    { hour in
                        Text("\(hour) hour\(hour == 1 ? "" : "s")")
                            .tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 140)

                Button("Save Goal")
                {
                    saveGoal()
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            List
            {
                Section("Goal History")
                {
                    if topicGoals.isEmpty
                    {
                        Text("No goals yet.")
                            .foregroundStyle(.secondary)
                    }
                    else
                    {
                        ForEach(topicGoals, id: \.id)
                        { goal in
                            HStack
                            {
                                VStack(alignment: .leading, spacing: 4)
                                {
                                    Text(formattedGoalTime(goal.targetSecondsPerDay))
                                        .font(.headline)
                                    Text(formattedDate(goal.createdAt))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .padding(.top)
        .navigationTitle("Goal")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveGoal()
    {
        let goal = Goal(
            topicID: topicID,
            targetSecondsPerDay: TimeInterval(selectedHours * 3_600),
            createdAt: .now
        )

        do
        {
            modelContext.insert(goal)
            try modelContext.save()
        }
        catch
        {}
    }

    private func formattedGoalTime(_ seconds: TimeInterval) -> String
    {
        let hours = Int(seconds) / 3_600
        return "\(hours) hour\(hours == 1 ? "" : "s") per day"
    }

    private func formattedDate(_ date: Date) -> String
    {
        date.formatted(date: .abbreviated, time: .shortened)
    }
}

#Preview
{
    NavigationStack
    {
        GoalView(topicID: Topic.sample.id, topicName: Topic.sample.name)
            .sampleDataContainer()
    }
}
