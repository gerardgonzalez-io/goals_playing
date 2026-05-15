import Foundation
import SwiftData

@Model
final class Goal
{
    var id: UUID
    var topicID: UUID?
    var targetSecondsPerDay: TimeInterval

    init(
        id: UUID = UUID(),
        topicID: UUID? = nil,
        targetSecondsPerDay: TimeInterval
    )
    {
        self.id = id
        self.topicID = topicID
        self.targetSecondsPerDay = targetSecondsPerDay
    }
}

extension Goal
{
    static let sample = sampleData[0]
    static let globalGoalSample = sampleData[1]
    static let focusedGoalSample = sampleData[2]

    static let sampleData = [
        Goal(topicID: Topic.sampleData[0].id, targetSecondsPerDay: 3_600),
        Goal(topicID: nil, targetSecondsPerDay: 7_200),
        Goal(topicID: Topic.sampleData[1].id, targetSecondsPerDay: 5_400)
    ]
}
