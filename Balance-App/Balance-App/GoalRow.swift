import SwiftUI

struct GoalRow: View {
    var goalTitle: String
    var progress: Int
    var goal: Int
    var isCompleted: Bool
    var isCheckable: Bool // Determines if the goal is checkable
    var currentStreak: Int = 0 // Default value for backward compatibility
    var longestStreak: Int = 0 // Default value for backward compatibility
    var updateAction: (Int) -> Void // Passes the updated progress back to the parent view

    @State private var isChecked: Bool = false // Local state to track checkable goals

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

                // Streak Display
                if currentStreak > 0 || longestStreak > 0 {
                    VStack(alignment: .leading, spacing: 5) {
                        if currentStreak > 0 {
                            Text("Current Streak: \(currentStreak) days")
                                .font(.caption2)
                                .foregroundColor(.green)
                                .italic()
                        }
                        if longestStreak > 0 {
                            Text("Longest Streak: \(longestStreak) days")
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .italic()
                        }
                    }
                }
            }

            Spacer()

            if isCheckable {
                Button(action: toggleCheckableGoal) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .foregroundColor(isChecked ? .white : .blue)
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
        .onAppear {
            isChecked = isCompleted
        }
    }

    // MARK: - Functions

    private func toggleCheckableGoal() {
        isChecked.toggle()
        let updatedProgress = isChecked ? goal + 1 : max(0, goal - 1) // Update progress based on state
        updateAction(updatedProgress) // Pass the updated progress back to the parent view
    }

    private func incrementGoal() {
        if progress < goal {
            let updatedProgress = progress + 1
            updateAction(updatedProgress) // Pass the updated progress back to the parent view
        }
    }
}
