import Foundation

/// Methods are static because calculations only depend on input parameters
/// Use `TimeCalculator.dailyTime(...)` instead of creating `TimeCalculator()`.
/// If this type later needs injected dependencies or state, instance methods would be more appropriate.
struct TimeCalculator
{
    static func dailyTime(from studySessions: [StudySession], on date: Date = .now, calendar: Calendar = .current) -> TimeInterval
    {
        studySessions
            .filter { calendar.isDate($0.endDate, inSameDayAs: date) }
            .reduce(0) { $0 + $1.durationSeconds }
    }

    static func totalTime(from studySessions: [StudySession]) -> TimeInterval
    {
        studySessions.reduce(0) { $0 + $1.durationSeconds }
    }
}
// compare how are you doing this in Goals if the methods has any validation
