import Foundation
import Testing
@testable import Goals_Playing

struct GoalEvaluatorTests
{
    let evaluator = GoalEvaluator()
    let calendar = Calendar.current

    @Test("Single goal applies to all future sessions")
    func singleGoalAppliesToAllFutureSessions()
    {
        let topicID = UUID()

        let goalDate = date(year: 2000, month: 1, day: 1)
        let goal = Goal(topicID: topicID, targetSecondsPerDay: 3_600, createdAt: goalDate)

        let sessionDay1 = date(year: 2000, month: 1, day: 1)
        let sessionDay2 = date(year: 2000, month: 2, day: 2)

        let sessions = [
            StudySession(topicID: topicID, startDate: sessionDay1, endDate: sessionDay1.addingTimeInterval(3_900)),
            StudySession(topicID: topicID, startDate: sessionDay2, endDate: sessionDay2.addingTimeInterval(3_900))
        ]

        let result = evaluator.reachedGoalsByDay(sessions: sessions, goals: [goal])

        #expect(result[calendar.startOfDay(for: sessionDay1)] == true)
        #expect(result[calendar.startOfDay(for: sessionDay2)] == true)
    }

    @Test("New goal applies from its creation date forward")
    func newGoalAppliesFromCreationDateForward()
    {
        let topicID = UUID()

        let firstGoalDate = date(year: 2000, month: 1, day: 1)
        let secondGoalDate = date(year: 2000, month: 4, day: 4)

        let firstGoal = Goal(topicID: topicID, targetSecondsPerDay: 3_600, createdAt: firstGoalDate)
        let secondGoal = Goal(topicID: topicID, targetSecondsPerDay: 5_400, createdAt: secondGoalDate)

        let sessionBeforeChange = date(year: 2000, month: 2, day: 2)
        let sessionAfterChange = date(year: 2000, month: 5, day: 5)

        let sessions = [
            StudySession(topicID: topicID, startDate: sessionBeforeChange, endDate: sessionBeforeChange.addingTimeInterval(3_900)),
            StudySession(topicID: topicID, startDate: sessionAfterChange, endDate: sessionAfterChange.addingTimeInterval(5_700))
        ]

        let result = evaluator.reachedGoalsByDay(sessions: sessions, goals: [firstGoal, secondGoal])

        #expect(result[calendar.startOfDay(for: sessionBeforeChange)] == true)
        #expect(result[calendar.startOfDay(for: sessionAfterChange)] == true)
    }

    @Test("Multiple goal changes across many days")
    func multipleGoalChangesAcrossManyDays()
    {
        let topicID = UUID()

        let goals = [
            Goal(topicID: topicID, targetSecondsPerDay: 1_800, createdAt: date(year: 2000, month: 1, day: 1)),
            Goal(topicID: topicID, targetSecondsPerDay: 2_400, createdAt: date(year: 2000, month: 1, day: 5)),
            Goal(topicID: topicID, targetSecondsPerDay: 3_000, createdAt: date(year: 2000, month: 1, day: 10)),
            Goal(topicID: topicID, targetSecondsPerDay: 3_600, createdAt: date(year: 2000, month: 1, day: 15)),
            Goal(topicID: topicID, targetSecondsPerDay: 4_200, createdAt: date(year: 2000, month: 1, day: 20)),
            Goal(topicID: topicID, targetSecondsPerDay: 4_800, createdAt: date(year: 2000, month: 1, day: 25)),
            Goal(topicID: topicID, targetSecondsPerDay: 5_400, createdAt: date(year: 2000, month: 1, day: 30))
        ]

        let sessions: [(Date, TimeInterval, Bool)] = [
            (date(year: 2000, month: 1, day: 3), 2_000, true),
            (date(year: 2000, month: 1, day: 7), 2_300, false),
            (date(year: 2000, month: 1, day: 12), 3_100, true),
            (date(year: 2000, month: 1, day: 17), 3_500, false),
            (date(year: 2000, month: 1, day: 22), 4_500, true),
            (date(year: 2000, month: 1, day: 27), 4_700, false),
            (date(year: 2000, month: 2, day: 1), 5_500, true)
        ]

        let studySessions = sessions.map {
            StudySession(topicID: topicID, startDate: $0.0, endDate: $0.0.addingTimeInterval($0.1))
        }

        let result = evaluator.reachedGoalsByDay(sessions: studySessions, goals: goals)

        for (day, _, expected) in sessions {
            #expect(result[calendar.startOfDay(for: day)] == expected)
        }
    }

    @Test("Multiple goals created on same day use latest goal of that day")
    func multipleGoalsOnSameDayUseLatestOne()
    {
        let topicID = UUID()

        let sameDayMorning = dateTime(year: 2000, month: 3, day: 10, hour: 9, minute: 0)
        let sameDayEvening = dateTime(year: 2000, month: 3, day: 10, hour: 18, minute: 0)

        let goals = [
            Goal(topicID: topicID, targetSecondsPerDay: 3_000, createdAt: date(year: 2000, month: 3, day: 1)),
            Goal(topicID: topicID, targetSecondsPerDay: 4_200, createdAt: sameDayMorning),
            Goal(topicID: topicID, targetSecondsPerDay: 5_400, createdAt: sameDayEvening),
            Goal(topicID: topicID, targetSecondsPerDay: 6_000, createdAt: date(year: 2000, month: 3, day: 20))
        ]

        let dayBeforeSameDayChange = date(year: 2000, month: 3, day: 5)
        let sameDayOfChange = date(year: 2000, month: 3, day: 10)
        let afterNextChange = date(year: 2000, month: 3, day: 22)

        let studySessions = [
            StudySession(topicID: topicID, startDate: dayBeforeSameDayChange, endDate: dayBeforeSameDayChange.addingTimeInterval(3_100)),
            StudySession(topicID: topicID, startDate: sameDayOfChange, endDate: sameDayOfChange.addingTimeInterval(5_000)),
            StudySession(topicID: topicID, startDate: afterNextChange, endDate: afterNextChange.addingTimeInterval(5_900))
        ]

        let result = evaluator.reachedGoalsByDay(sessions: studySessions, goals: goals)

        #expect(result[calendar.startOfDay(for: dayBeforeSameDayChange)] == true)
        #expect(result[calendar.startOfDay(for: sameDayOfChange)] == false)
        #expect(result[calendar.startOfDay(for: afterNextChange)] == false)
    }

    private func date(year: Int, month: Int, day: Int) -> Date
    {
        let components = DateComponents(calendar: calendar, year: year, month: month, day: day)
        return components.date!
    }

    private func dateTime(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date
    {
        let components = DateComponents(
            calendar: calendar,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        return components.date!
    }
}
