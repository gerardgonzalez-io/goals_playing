import Foundation

struct SessionInterval: Identifiable, Codable, Hashable
{
    let id: UUID
    var startDate: Date
    var endDate: Date

    var durationSeconds: TimeInterval
    {
        endDate.timeIntervalSince(startDate)
    }

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date
    )
    {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
}
