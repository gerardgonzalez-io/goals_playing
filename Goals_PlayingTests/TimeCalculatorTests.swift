import Foundation
import Testing
@testable import Goals_Playing

struct TimeCalculatorTests
{
    @Test("Daily time sums only sessions on selected day")
    func dailyTimeSumsOnlySameDaySessions()
    {
        let calendar = Calendar(identifier: .gregorian)
        let selectedDate = Date(timeIntervalSince1970: 1_750_000_000)
        let topicID = UUID()

        let sessions = [
            StudySession(
                topicID: topicID,
                startDate: selectedDate.addingTimeInterval(-3_600),
                endDate: selectedDate.addingTimeInterval(-1_800),
                durationSeconds: 1_800
            ),
            StudySession(
                topicID: topicID,
                startDate: selectedDate.addingTimeInterval(-7_200),
                endDate: selectedDate.addingTimeInterval(-3_600),
                durationSeconds: 3_600
            ),
            StudySession(
                topicID: topicID,
                startDate: selectedDate.addingTimeInterval(-90_000),
                endDate: selectedDate.addingTimeInterval(-86_400),
                durationSeconds: 3_600
            )
        ]

        let result = TimeCalculator.dailyTime(from: sessions, on: selectedDate, calendar: calendar)
        #expect(result == 5_400)
    }

    @Test("Total time sums all sessions", arguments: [0, 1, 2, 3])
    func totalTimeSumsAllSessions(usingFirst count: Int)
    {
        let topicID = UUID()
        let allSessions = [
            StudySession(topicID: topicID, startDate: .now, endDate: .now, durationSeconds: 900),
            StudySession(topicID: topicID, startDate: .now, endDate: .now, durationSeconds: 1_800),
            StudySession(topicID: topicID, startDate: .now, endDate: .now, durationSeconds: 2_700)
        ]

        let sessions = Array(allSessions.prefix(count))
        let expected = sessions.reduce(0) { $0 + $1.durationSeconds }

        let result = TimeCalculator.totalTime(from: sessions)
        #expect(result == expected)
    }
}
