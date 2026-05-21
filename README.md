# Goals_Playing

## Features
1. Show a timer.
2. Set a general goal.
3. Show current and longest streak.
4. Show daily and total study time.

## App Behavior
### How are records added?

1. Goal records are added:
- By default when the user creates a topic.
- When the user manually changes the goal.

2. StudySession records are created:
- When the user starts a session (adds `startDate`).
- When the user stops a session (adds `endDate`).
- When the user leaves the timer screen (adds `endDate`).

3. SessionInterval records are created:
- When the user starts a session (adds `startDate`).
- When the user resumes a session (adds `startDate`).
- When the user pauses a session (adds `endDate`).

### Rules
- The `startDate` of a `StudySession` and the `startDate` of its first `SessionInterval` must be the same.
- If the user leaves the timer screen while an interval is running, set `endDate` for both `StudySession` and `SessionInterval`.
- If the user leaves the timer screen while the timer is stopped, the interval `endDate` is already set, so only set `endDate` for `StudySession`.

## App Logic
### How are records computed?

1. `TimeCalculator`: 
- Calculates daily and total study time from intervals.
- If an interval crosses into the next day, daily time is split between both days.


- `StreakCalculator`: Calculates current and longest streaks.
- `GoalEvaluator`: Evaluates whether daily goals are reached.
