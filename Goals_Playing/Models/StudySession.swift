import Foundation
import SwiftData

@Model
final class StudySession
{
    var id: UUID
    var topicID: UUID
    var startDate: Date
    var endDate: Date
    var durationSeconds: TimeInterval

    init(
        id: UUID = UUID(),
        topicID: UUID,
        startDate: Date,
        endDate: Date,
        durationSeconds: TimeInterval
    )
    {
        self.id = id
        self.topicID = topicID
        self.startDate = startDate
        self.endDate = endDate
        self.durationSeconds = durationSeconds
    }
}

extension StudySession
{
    static let sample = sampleData[0]
    static let longSample = sampleData[1]
    static let shortSample = sampleData[2]

    static let sampleData = [
        StudySession(
            topicID: Topic.sampleData[0].id,
            startDate: .now.addingTimeInterval(-7_200),
            endDate: .now.addingTimeInterval(-3_600),
            durationSeconds: 3_600
        ),
        StudySession(
            topicID: Topic.sampleData[1].id,
            startDate: .now.addingTimeInterval(-172_800),
            endDate: .now.addingTimeInterval(-169_200),
            durationSeconds: 3_600
        ),
        StudySession(
            topicID: Topic.sampleData[2].id,
            startDate: .now.addingTimeInterval(-86_400),
            endDate: .now.addingTimeInterval(-85_200),
            durationSeconds: 1_200
        )
    ]
}
