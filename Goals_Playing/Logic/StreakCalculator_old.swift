//
//  StreakCalculator_old.swift
//  Goals_Playing
//
//  Created by Adolfo Gerard Montilla Gonzalez on 21-05-26.
//

import Foundation
// Calculates streaks based StudySession dates (Old Model)
struct StreakCalculatorOld
{
    let calendar = Calendar.current

    /// Counts consecutive successful days based on `StudySession` records.
    /// A day is successful if there is at least one session registered on that day.
    /// - Precondition: `sessions` must be sorted by `endDate`, from earliest to latest.
    func calculateStreak(for sessions: [StudySession]) -> Int
    {
        let startOfToday = calendar.startOfDay(for: .now)
        let endOfToday = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfToday)!

        let daysAgoArray = sessions
            .reversed()
            .map(\.endDate!)
            .map { calendar.dateComponents([.day], from: $0, to: endOfToday) }
            .compactMap { $0.day }

        var streak = 0
        for daysAgo in daysAgoArray
        {
            if daysAgo == streak
            {
                // Multiple sessions in one day still count as a single streak day.
                continue
            }
            else if daysAgo == streak + 1
            {
                // Found the next consecutive day.
                streak += 1
            }
            else
            {
                // Any gap larger than one day breaks the streak.
                break
            }
        }

        // If there is at least one session today, include today in the streak.
        if daysAgoArray.first == 0
        {
            streak += 1
        }

        return streak
    }
}
