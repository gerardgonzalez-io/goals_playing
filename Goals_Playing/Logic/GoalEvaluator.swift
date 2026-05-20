import Foundation

/*
 ◇ Test "Measure reachedGoalsByDay execution time" started.
 
 reachedGoalsByDay took: 0.036813667 seconds

 ✔ Test "Measure reachedGoalsByDay execution time" passed after 0.048 seconds.
 ✔ Suite GoalEvaluatorTests passed after 0.049 seconds.
 ✔ Test run with 1 test in 1 suite passed after 0.050 seconds.
 */
struct GoalEvaluator {
    let calendar = Calendar.current

    func reachedGoalsByDay(sessions: [StudySession], goals: [Goal]) -> [Date: Bool]
    {
        let completedByDay = completedSecondsByDay(from: sessions)
        let days = completedByDay.keys.sorted()

        guard !days.isEmpty else {
            return [:]
        }

        let effectiveGoals = effectiveGoalsByDay(from: goals)

        var result: [Date: Bool] = [:]
        result.reserveCapacity(days.count)

        var activeGoal: Goal?
        var goalIndex = 0
        let goalDays = effectiveGoals.keys.sorted()

        for day in days
        {
            while goalIndex < goalDays.count, goalDays[goalIndex] <= day
            {
                activeGoal = effectiveGoals[goalDays[goalIndex]]
                goalIndex += 1
            }

            guard let goal = activeGoal else
            {
                result[day] = false
                continue
            }

            result[day] = completedByDay[day, default: 0] >= goal.targetSecondsPerDay
        }

        return result
    }

    private func completedSecondsByDay(from sessions: [StudySession]) -> [Date: TimeInterval]
    {
        var totals: [Date: TimeInterval] = [:]

        for session in sessions where session.startDate < session.endDate
        {
            var currentDay = calendar.startOfDay(for: session.startDate)

            while currentDay < session.endDate
            {
                guard let dayInterval = calendar.dateInterval(of: .day, for: currentDay) else
                {
                    break
                }

                let overlapStart = max(session.startDate, dayInterval.start)
                let overlapEnd = min(session.endDate, dayInterval.end)

                if overlapStart < overlapEnd
                {
                    totals[currentDay, default: 0] += overlapEnd.timeIntervalSince(overlapStart)
                }

                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDay) else
                {
                    break
                }

                currentDay = nextDay
            }
        }

        return totals
    }

    private func effectiveGoalsByDay(from goals: [Goal]) -> [Date: Goal]
    {
        var effectiveGoals: [Date: Goal] = [:]

        for goal in goals
        {
            let day = calendar.startOfDay(for: goal.createdAt)

            if let existing = effectiveGoals[day]
            {
                if goal.createdAt > existing.createdAt
                {
                    effectiveGoals[day] = goal
                }
            }
            else
            {
                effectiveGoals[day] = goal
            }
        }

        return effectiveGoals
    }
}
// One small behavior note: this keeps your existing logic where only days covered by sessions appear in the result. Days with goals but no sessions are still not included.
