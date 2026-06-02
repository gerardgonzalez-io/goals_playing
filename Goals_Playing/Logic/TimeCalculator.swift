import Foundation

/// Utility for calculating study time from session intervals (real active study time).
///
/// Global behavior:
/// - A `StudySession` can contain multiple `SessionInterval` values to represent pause/resume cycles.
/// - Time is always calculated from interval ranges, not from the session's outer start/end dates.
/// - `dailyTime` sums only the overlap between each interval and the requested day, so intervals
///   crossing midnight are automatically split across days.
/// - `totalTime` sums the full duration of all intervals across all sessions.
///
struct TimeCalculator
{
    /*
     ◇ Test "Measure dailyTime execution time" started.
     dailyTime took: 0.018348834 seconds
     */
    static func dailyTime(
        from studySessions: [StudySession],
        on date: Date = .now,
        calendar: Calendar = .current
    ) -> TimeInterval
    {
        guard let dayInterval = calendar.dateInterval(of: .day, for: date) else
        {
            return 0
        }

        let dayStart = dayInterval.start
        let dayEnd = dayInterval.end

        var total: TimeInterval = 0

        for session in studySessions
        {
            for interval in session.sessionIntervals
            {
                let overlapStart = max(interval.startDate, dayStart)
                // End dates always have to exists
                let overlapEnd = min(interval.endDate!, dayEnd)

                if overlapStart < overlapEnd {
                    total += overlapEnd.timeIntervalSince(overlapStart)
                }
            }
        }

        return total
    }

    /*
     ◇ Test "Measure totalTime execution time" started.
     totalTime took: 0.022743 seconds
    */
    static func totalTime(from studySessions: [StudySession]) -> TimeInterval
    {
        var total: TimeInterval = 0

        for session in studySessions
        {
            for interval in session.sessionIntervals
            {
                total += interval.durationSeconds
            }
        }

        return total
    }
}

