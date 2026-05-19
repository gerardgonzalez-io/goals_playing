import Foundation

/// Methods are static because calculations only depend on input parameters
/// Use `TimeCalculator.dailyTime(...)` instead of creating `TimeCalculator()`.
/// If this type later needs injected dependencies or state, instance methods would be more appropriate.
struct TimeCalculator
{
    static func dailyTime(
        from studySessions: [StudySession],
        on date: Date = .now,
        calendar: Calendar = .current
    ) -> TimeInterval {
        guard let dayInterval = calendar.dateInterval(of: .day, for: date) else {
            return 0
        }

        return studySessions.reduce(0) { total, session in
            let overlapStart = max(session.startDate, dayInterval.start)
            let overlapEnd = min(session.endDate, dayInterval.end)

            guard overlapStart < overlapEnd else {
                return total
            }

            return total + overlapEnd.timeIntervalSince(overlapStart)
        }
    }

    static func totalTime(from studySessions: [StudySession]) -> TimeInterval
    {
        studySessions.reduce(0) { $0 + $1.durationSeconds }
    }
}

