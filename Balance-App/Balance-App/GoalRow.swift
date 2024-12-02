import SwiftUI

struct GoalRow: View {
    var goalTitle: String
    var progress: Int
    var goal: Int
    var isCompleted: Bool
    var isCheckable: Bool // Determines if the goal is checkable
    var updateAction: (Int) -> Void // Passes the updated progress back to the parent view

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                    .foregroundColor(isCompleted ? .white : .black)

                if isCheckable {
                    Text("Tap the box to toggle completion.")
                        .font(.caption)
                        .foregroundColor(isCompleted ? .white : .gray)
                } else {
                    Text("\(progress) / \(goal)")
                        .font(.caption)
                        .foregroundColor(isCompleted ? .white : .gray)
                }
            }

            Spacer()

            if isCheckable {
                Button(action: toggleCheckableGoal) {
                    Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                        .foregroundColor(isCompleted ? .white : .blue)
                        .font(.title2)
                }
            } else {
                Button(action: incrementGoal) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle.fill")
                        .foregroundColor(isCompleted ? .white : .blue)
                        .font(.title2)
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, minHeight: 60)
        .background(
            Color(isCompleted ? UIColor.systemYellow : UIColor.systemGray6)
                .opacity(0.8)
                .animation(.easeInOut, value: isCompleted)
        )
        .cornerRadius(10)
        .shadow(radius: isCompleted ? 5 : 3)
    }

    // MARK: - Functions

    private func toggleCheckableGoal() {
        // Toggle the completion status
        let updatedProgress = isCompleted ? max(0, goal - 1) : goal
        updateAction(updatedProgress) // Pass the updated progress back to the parent view
    }

    private func incrementGoal() {
        if progress < goal {
            let updatedProgress = progress + 1
            updateAction(updatedProgress) // Pass the updated progress back to the parent view
        }
    }
}
