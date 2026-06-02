//
//  TimeCalculator_old.swift
//  Goals_Playing
//
//  Created by Adolfo Gerard Montilla Gonzalez on 21-05-26.
//

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
/// Methods are static because calculations only depend on input parameters.
/// Use `TimeCalculator.dailyTime(...)` instead of creating `TimeCalculator()`.
/// If this type later needs injected dependencies or state, instance methods would be more appropriate.
struct TimeCalculatorOld
{
    /*
     ◇ Test "Measure dailyTime execution time" started.
     dailyTime took: 0.018896959 seconds
    */
    static func dailyTime(
        from studySessions: [StudySession],
        on date: Date = .now,
        calendar: Calendar = .current
    ) -> TimeInterval {
        guard let dayInterval = calendar.dateInterval(of: .day, for: date) else {
            return 0
        }

        return studySessions.reduce(0) { total, session in
            let intervalsTotal = session.sessionIntervals.reduce(0) { intervalTotal, interval in
                let overlapStart = max(interval.startDate, dayInterval.start)
                let overlapEnd = min(interval.endDate!, dayInterval.end)

                guard overlapStart < overlapEnd else {
                    return intervalTotal
                }

                return intervalTotal + overlapEnd.timeIntervalSince(overlapStart)
            }

            return total + intervalsTotal
        }
    }

    /*
     ◇ Test "Measure totalTime execution time" started.
     totalTime took: 0.021160417 seconds
    */
    static func totalTime(from studySessions: [StudySession]) -> TimeInterval
    {
        studySessions.reduce(0) { total, session in
            total + session.sessionIntervals.reduce(0) { $0 + $1.durationSeconds }
        }
    }
}
