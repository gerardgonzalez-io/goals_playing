import Foundation
import Observation

@MainActor
@Observable
final class Timer
{
    var secondsElapsed = 0
    var secondsRemaining = 0
    var isRunning = false

    private var lengthInMinutes: Int
    private weak var internalTimer: Foundation.Timer?
    private var startDate: Date?

    init(lengthInMinutes: Int = 25)
    {
        self.lengthInMinutes = lengthInMinutes
        self.secondsRemaining = lengthInMinutes * 60
    }

    func start()
    {
        guard !isRunning else { return }
        isRunning = true
        startDate = Date().addingTimeInterval(TimeInterval(-secondsElapsed))

        internalTimer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.update()
        }
        internalTimer?.tolerance = 0.1
    }

    func stop()
    {
        internalTimer?.invalidate()
        internalTimer = nil
        isRunning = false
    }

    func reset(lengthInMinutes: Int? = nil)
    {
        stop()
        if let newLength = lengthInMinutes {
            self.lengthInMinutes = newLength
        }
        secondsElapsed = 0
        secondsRemaining = self.lengthInMinutes * 60
        startDate = nil
    }

    private func update()
    {
        guard let startDate, isRunning else { return }

        let elapsed = Int(Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
        secondsElapsed = max(elapsed, 0)

        let totalSeconds = lengthInMinutes * 60
        secondsRemaining = max(totalSeconds - secondsElapsed, 0)

        if secondsRemaining == 0 {
            stop()
        }
    }
}
