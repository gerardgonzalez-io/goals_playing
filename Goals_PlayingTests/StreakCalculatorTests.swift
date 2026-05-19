import Foundation
import Testing
@testable import Goals_Playing

struct StreakCalculatorTests
{
    let streakCalculator = StreakCalculator()
    let now = Date.now

    struct Input
    {
        let expectedStreak: Int
        let days: [Int]
    }

    @Test("Streak calculations", arguments: [
        Input(expectedStreak: 0, days: []),

        Input(expectedStreak: 1, days: [0]),
        Input(expectedStreak: 1, days: [-1]),
        Input(expectedStreak: 0, days: [-2]),

        Input(expectedStreak: 1, days: [0, 0]),
        Input(expectedStreak: 1, days: [-1, -1]),
        Input(expectedStreak: 0, days: [-2, -2]),

        Input(expectedStreak: 3, days: [-2, -1, 0]),
        Input(expectedStreak: 2, days: [-3, -1, 0]),
        Input(expectedStreak: 3, days: [-3, -2, -1]),
        Input(expectedStreak: 2, days: [-4, -2, -1])
    ])
    func testCalculations(input: Input)
    {
        let sessions = input.days.map {
            let endDate = Calendar.current.date(byAdding: .day, value: $0, to: now)!
            let startDate = endDate.addingTimeInterval(-1_800)
            return StudySession(
                topicID: UUID(),
                startDate: startDate,
                endDate: endDate
            )
        }

        let streak = streakCalculator.calculateStreak(for: sessions)
        #expect(streak == input.expectedStreak, "\(input.days)")
    }
}
