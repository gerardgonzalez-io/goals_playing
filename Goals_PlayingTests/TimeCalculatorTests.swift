import Foundation
import Testing
@testable import Goals_Playing

struct TimeCalculatorTests
{
    @Test("Daily time sums only sessions on selected day")
    func dailyTimeSumsOnlySameDaySessions()
    {
        let calendar = Calendar(identifier: .gregorian)
        let topicID = UUID()

        let day10 = calendar.date(from: DateComponents(year: 2000, month: 1, day: 10, hour: 12, minute: 0))!
        let day11 = calendar.date(from: DateComponents(year: 2000, month: 1, day: 11, hour: 12, minute: 0))!
        let day12 = calendar.date(from: DateComponents(year: 2000, month: 1, day: 12, hour: 12, minute: 0))!

        let crossDayStart = calendar.date(from: DateComponents(year: 2000, month: 1, day: 10, hour: 23, minute: 30))!
        let crossDayEnd = calendar.date(from: DateComponents(year: 2000, month: 1, day: 11, hour: 0, minute: 30))!

        let sameDay12Start = calendar.date(from: DateComponents(year: 2000, month: 1, day: 12, hour: 13, minute: 0))!
        let sameDay12End = calendar.date(from: DateComponents(year: 2000, month: 1, day: 12, hour: 15, minute: 0))!

        let sessions = [
            StudySession(
                topicID: topicID,
                startDate: crossDayStart,
                endDate: crossDayEnd
            ),
            StudySession(
                topicID: topicID,
                startDate: sameDay12Start,
                endDate: sameDay12End
            )
        ]

        let resultDay10 = TimeCalculator.dailyTime(from: sessions, on: day10, calendar: calendar)
        let resultDay11 = TimeCalculator.dailyTime(from: sessions, on: day11, calendar: calendar)
        let resultDay12 = TimeCalculator.dailyTime(from: sessions, on: day12, calendar: calendar)

        #expect(resultDay10 == 1_800)
        #expect(resultDay11 == 1_800)
        #expect(resultDay12 == 7_200)
    }

    @Test("Total time sums all sessions", arguments: [0, 1, 2, 3])
    func totalTimeSumsAllSessions(usingFirst count: Int)
    {
        let topicID = UUID()
        let now = Date.now
        let allSessions = [
            StudySession(topicID: topicID, startDate: now, endDate: now.addingTimeInterval(900)),
            StudySession(topicID: topicID, startDate: now, endDate: now.addingTimeInterval(1_800)),
            StudySession(topicID: topicID, startDate: now, endDate: now.addingTimeInterval(2_700))
        ]

        let sessions = Array(allSessions.prefix(count))
        let expected = sessions.reduce(0) { $0 + $1.durationSeconds }

        let result = TimeCalculator.totalTime(from: sessions)
        #expect(result == expected)
    }
}
