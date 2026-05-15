import SwiftData
import SwiftUI

@main
struct Goals_PlayingApp: App
{
    let dataContainer = DataContainer()

    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
                //.environment(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
