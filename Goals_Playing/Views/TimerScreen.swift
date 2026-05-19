import SwiftData
import SwiftUI

struct TimerScreen: View
{
    @Environment(\.modelContext) private var modelContext

    let topicID: UUID
    let topicName: String

    @State private var isRunning = false
    @State private var accumulatedElapsed: TimeInterval = 0
    @State private var activeSession: StudySession?
    @State private var now = Date()
    @State private var tickerTask: Task<Void, Never>?

    private var currentElapsed: TimeInterval
    {
        accumulatedElapsed + (activeSession.map { now.timeIntervalSince($0.startDate) } ?? 0)
    }

    var body: some View
    {
        VStack(spacing: 20)
        {
            topicCard

            Text(formattedTime(currentElapsed))
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 12)
            {
                Button(isRunning ? "Pause" : "Resume")
                {
                    isRunning ? pauseSession() : startSession()
                }
                .buttonStyle(.borderedProminent)

                Button("Stop")
                {
                    stopTimer()
                }
                .buttonStyle(.bordered)
                .disabled(!isRunning && accumulatedElapsed == 0)
            }
        }
        .padding()
        .navigationTitle("Timer")
        .onAppear
        {
            startSessionIfNeeded()
        }
        .onDisappear
        {
            closeAndReset()
        }
    }

    private var topicCard: some View
    {
        HStack(spacing: 12)
        {
            Image(systemName: "book.fill")
                .foregroundStyle(.tint)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4)
            {
                Text("Studying Topic")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(topicName)
                    .font(.headline)
            }

            Spacer()
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func startSessionIfNeeded()
    {
        guard !isRunning, activeSession == nil else { return }
        startSession()
    }

    private func startSession()
    {
        guard !isRunning else { return }

        let session = StudySession(topicID: topicID, startDate: .now, endDate: .now)
        modelContext.insert(session)
        activeSession = session
        now = .now
        isRunning = true
        startTicker()
    }

    private func pauseSession()
    {
        guard isRunning, let activeSession else { return }

        activeSession.endDate = .now
        accumulatedElapsed += activeSession.durationSeconds

        isRunning = false
        self.activeSession = nil
        stopTicker()
    }

    private func stopTimer()
    {
        if isRunning {
            pauseSession()
        }

        accumulatedElapsed = 0
        now = .now
        activeSession = nil
        isRunning = false
        stopTicker()
    }

    private func closeAndReset()
    {
        if isRunning {
            pauseSession()
        }

        accumulatedElapsed = 0
        now = .now
        activeSession = nil
        isRunning = false
        stopTicker()
    }

    private func startTicker()
    {
        stopTicker()

        tickerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                if isRunning {
                    now = .now
                }
            }
        }
    }

    private func stopTicker()
    {
        tickerTask?.cancel()
        tickerTask = nil
    }

    private func formattedTime(_ seconds: TimeInterval) -> String
    {
        let value = max(Int(seconds), 0)
        let hours = value / 3_600
        let minutes = (value % 3_600) / 60
        let remainingSeconds = value % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
}

#Preview
{
    NavigationStack {
        TimerScreen(topicID: UUID(), topicName: "Mathematics")
    }
    .modelContainer(for: [StudySession.self], inMemory: true)
}
