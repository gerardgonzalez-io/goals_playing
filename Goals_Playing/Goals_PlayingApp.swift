import SwiftData
import SwiftUI

@main
struct Goals_PlayingApp: App
{
    /*
    private enum UserDefaultsKeys
    {
        static let launchID = "launchID"
        static let sessionID = "sessionID"
        static let lastSeenLaunchID = "lastSeenLaunchID"
        static let timerSnapshotSeconds = "timerSnapshotSeconds"
        static let timerSnapshotDate = "timerSnapshotDate"
        static let timerSnapshotWasRunning = "timerSnapshotWasRunning"
    }
    */
    let dataContainer = DataContainer()
    /*
    let launchID = UUID()

    init()
    {
        prepareLaunchState()
    }
    */
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                .environment(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
    /*
    private func prepareLaunchState()
    {
        let defaults = UserDefaults.standard
        let currentLaunchID = launchID.uuidString

        guard let savedLaunchID = defaults.string(forKey: UserDefaultsKeys.launchID)
        else
        {
            defaults.set(currentLaunchID, forKey: UserDefaultsKeys.launchID)
            return
        }

        guard savedLaunchID != currentLaunchID
        else
        {
            return
        }

        deleteSavedSessionIfNeeded()
        defaults.set(currentLaunchID, forKey: UserDefaultsKeys.launchID)
    }

    private func deleteSavedSessionIfNeeded()
    {
        let defaults = UserDefaults.standard

        guard let savedSessionID = defaults.string(forKey: UserDefaultsKeys.sessionID),
              let sessionID = UUID(uuidString: savedSessionID)
        else
        {
            return
        }

        do
        {
            let descriptor = FetchDescriptor<StudySession>(
                predicate: #Predicate
                { session in
                    session.id == sessionID
                }
            )

            let sessions = try dataContainer.context.fetch(descriptor)

            for session in sessions
            {
                dataContainer.context.delete(session)
            }

            deleteSessionIDAndTimerSnapshotFromUserDefaults()
            try dataContainer.context.save()
        }
        catch
        {}
    }

    private func deleteSessionIDAndTimerSnapshotFromUserDefaults()
    {
        let defaults = UserDefaults.standard

        defaults.removeObject(forKey: UserDefaultsKeys.sessionID)
        //defaults.removeObject(forKey: UserDefaultsKeys.lastSeenLaunchID)
        defaults.removeObject(forKey: UserDefaultsKeys.timerSnapshotSeconds)
        defaults.removeObject(forKey: UserDefaultsKeys.timerSnapshotDate)
        defaults.removeObject(forKey: UserDefaultsKeys.timerSnapshotWasRunning)
    }
    */
}
