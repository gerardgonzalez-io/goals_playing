import SwiftData
import SwiftUI

struct TopicEntryView: View
{
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var topicName = ""

    let existingNames: Set<String>

    private var trimmedName: String
    {
        topicName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isDuplicateName: Bool
    {
        existingNames.contains(trimmedName.lowercased())
    }

    private var canSave: Bool
    {
        !trimmedName.isEmpty && !isDuplicateName
    }

    var body: some View
    {
        Form
        {
            Section("Topic")
            {
                TextField("Topic name", text: $topicName)
                    .textInputAutocapitalization(.words)

                if isDuplicateName {
                    Text("A topic with this name already exists.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
        }
        .toolbar
        {
            ToolbarItem(placement: .topBarLeading)
            {
                Button("Cancel")
                {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing)
            {
                Button("Save")
                {
                    saveTopic()
                }
                .disabled(!canSave)
            }
        }

    }

    private func saveTopic()
    {
        guard canSave else { return }
        modelContext.insert(Topic(name: trimmedName))
        dismiss()
    }
}

#Preview
{
    NavigationStack
    {
        TopicEntryView(existingNames: ["math", "history"])
            .modelContainer(for: [Topic.self], inMemory: true)
    }
}
