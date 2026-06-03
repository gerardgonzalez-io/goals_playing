import SwiftData
import SwiftUI

struct TimerView: View
{
    @Environment(\.modelContext) private var modelContext

    let topicID: UUID
    let topicName: String

    @State private var timer = StudySessionTimer()
    
    // Study if this properties have to be @States
    @State private var currentSession: StudySession?
    @State private var currentInterval: SessionInterval?

    private var currentElapsed: TimeInterval
    {
        TimeInterval(timer.secondsElapsed)
    }

    private var isRunning: Bool
    {
        timer.isRunning
    }

    private var primaryButtonTitle: String
    {
        if currentSession == nil
        {
            return "Start"
        }

        return isRunning ? "Pause" : "Resume"
    }

    var body: some View
    {
        VStack(spacing: 20)
        {
            topicCard
            
            Spacer()
            
            Text(formattedTime(currentElapsed))
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 12)
            {
                Button(primaryButtonTitle)
                {
                    performPrimaryTimerAction()
                }
                .buttonStyle(.bordered)

                Button("Stop")
                {
                    do
                    {
                        try stopSession()
                    }
                    catch
                    {}
                }
                .buttonStyle(.bordered)
                .disabled(currentSession == nil)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Timer")
        .onAppear
        {
            do
            {
                try startSession()
            }
            catch
            {}
        }
        .onDisappear
        {
            do
            {
                try stopSession()
            }
            catch
            {}
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

    private func startSession() throws
    {
        guard timer.isRunning == false,
               currentSession == nil,
                currentInterval == nil
        else
        {
            print("start - return")
            return
        }
        print("start - in")
        print("Session: \(String(describing: currentSession))")
        print("Interval: \(String(describing: currentInterval))")
        let now = Date.now

        let session = StudySession(
            topicID: topicID,
            startDate: now
        )

        let interval = SessionInterval(
            startDate: now,
            studySession: session
        )

        session.sessionIntervals.append(interval)

        modelContext.insert(session)

        currentSession = session
        currentInterval = interval

        try modelContext.save()

        timer.start()
    }
    
    private func stopSession() throws
    {
        guard currentSession != nil
        else
        {
            print("stop - return")
            return
        }
        print("stop - in")
        
        print("Session: \(String(describing: currentSession))")
        print("Interval: \(String(describing: currentInterval))")
    
        let now = Date.now

        currentSession?.endDate = now
        
        if currentInterval?.endDate == nil
        {
            currentInterval?.endDate = now
        }

        try modelContext.save()

        currentSession = nil
        currentInterval = nil
        
        timer.reset()
    }

    private func resumeSession() throws
    {
        guard timer.isRunning == false,
                currentSession != nil
        else
        {
            print("resume - return")
            return
        }
        print("resume - in")
        print("Interval: \(String(describing: currentInterval))")

        let now = Date.now

        let interval = SessionInterval(
            startDate: now,
            studySession: currentSession
        )
        
        currentSession?.sessionIntervals.append(interval)
        currentInterval = interval
        
        timer.start()
    }
    
    private func pauseSession() throws
    {
        guard timer.isRunning == true
        else
        {
            print("pause - return")
            return
        }
        print("pause - in")
        print("Interval: \(String(describing: currentInterval))")
        let now = Date.now
        
        currentInterval?.endDate = now
        
        try modelContext.save()
        timer.stop()
        
        currentInterval = nil
    }

    private func performPrimaryTimerAction()
    {
        do
        {
            if currentSession == nil
            {
                try startSession()
            }
            else if isRunning
            {
                try pauseSession()
            }
            else
            {
                try resumeSession()
            }
        }
        catch
        {}
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
    NavigationStack
    {
        TimerView(topicID: UUID(), topicName: "Mathematics")
    }
    .modelContainer(for: [StudySession.self], inMemory: true)
}
