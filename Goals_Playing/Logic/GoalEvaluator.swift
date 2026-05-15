import Foundation

struct GoalEvaluator
{
    let calendar = Calendar.current

    func reachedGoalsByDay(sessions: [StudySession], goals: [Goal]) -> [Date: Bool]
    {
        let uniqueDays = Set(sessions.map { calendar.startOfDay(for: $0.endDate) })
        var result: [Date: Bool] = [:]

        for day in uniqueDays {
            result[day] = reachedGoal(on: day, sessions: sessions, goals: goals)
        }

        return result
    }
    
    private func reachedGoal(on day: Date, sessions: [StudySession], goals: [Goal]) -> Bool
    {
        guard let goal = goal(for: day, in: goals) else { return false }
        let dayTotal = sessionsCompleted(on: day, sessions: sessions)
        return dayTotal >= goal.targetSecondsPerDay
    }

    private func sessionsCompleted(on day: Date, sessions: [StudySession]) -> TimeInterval
    {
        let normalizedDay = calendar.startOfDay(for: day)
        return sessions
            .filter { calendar.isDate($0.endDate, inSameDayAs: normalizedDay) }
            .reduce(0) { $0 + $1.durationSeconds }
    }

    private func goal(for day: Date, in goals: [Goal]) -> Goal?
    {
        guard !goals.isEmpty else { return nil }

        let normalizedDay = calendar.startOfDay(for: day)

        // Group goals by day so multiple goals created on the same day are treated as one effective day.
        let groupedByDay = Dictionary(grouping: goals) { calendar.startOfDay(for: $0.createdAt) }
        let effectiveDays = groupedByDay.keys.sorted()

        guard let activeDay = effectiveDays.last(where: { $0 <= normalizedDay }) else {
            return nil
        }

        // If multiple goals exist on the same day, use the latest created one for that effective day.
        return groupedByDay[activeDay]?.max(by: { $0.createdAt < $1.createdAt })
    }
}
