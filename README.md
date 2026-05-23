# Goals_Playing

## Features
1. Show a timer.
2. Set a general goal.
3. Show current streak.
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

### Rules (based on the behavior of the user in the App)
- The `startDate` of a `StudySession` and the `startDate` of its first `SessionInterval` must be the same.
- If the user leaves the timer screen while an interval is running, set `endDate` for both `StudySession` and `SessionInterval`.
- If the user leaves the timer screen while the timer is stopped, the interval `endDate` is already set, so only set `endDate` for `StudySession`.
- If the user presses the Stop button while the session is paused, do not set `endDate` again for `SessionInterval`.


## App Logic
### How are records computed?

1. `TimeCalculator`: 
- Calculates daily and total study time from intervals.
- If an interval crosses into the next day, daily time is split between both days.

2.  `StreakCalculator`: 
- Calculates current streak.
- Counts streak days from real interval activity (`SessionInterval`), not from outer session duration.
- Rule: a day counts if at least one interval overlaps that day.
- If an interval crosses midnight, activity is split and both days can count.
- Current streak stays active if the user studied today or yesterday.
- The streak breaks after one full missed day gap.

3. `GoalEvaluator`:
- Evaluates if each studied day reached the active goal for that topic.
- Uses real study time from `SessionInterval` values (not session outer duration).
- Splits cross-day intervals and adds the overlap to each corresponding day.
- Resolves active goal by timestamp:
  the active goal is the latest goal created at or before the first study timestamp of that day.

Example timeline:
- `2026-12-01 00:00` Goal A created: `1h`
- `2026-12-01 18:00` Goal B created: `1h 30m`
- Session on `2026-12-01 09:00` with intervals totaling `1h 20m`
Result for `2026-12-01`: reached (`1h 20m >= 1h`) because Goal A is active at 09:00.

- Session on `2026-12-01 20:00` with intervals totaling `1h 20m`
Result for `2026-12-01`: not reached (`1h 20m < 1h 30m`) because Goal B is active at 20:00.
- Evaluates whether daily goal are reached.
