import SwiftUI

struct CustomGoalsDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var customGoals: [Goal] = [] // Custom goals fetched from Core Data

    var body: some View {
        ZStack {
            // Background image
            Image("background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text("Custom Goals")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: 0, y: 2)
                    .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 15) {
                        // Add a heading for the custom goals list
                        Text("Your Goals")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        ForEach(customGoals, id: \.self) { goal in
                            goalProgressRow(for: goal)
                        }
                    }
                    .padding(.horizontal, 20) // Add horizontal padding to constrain width
                    .background(Color(UIColor.systemGray6).opacity(0.8))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .frame(maxWidth: 400) // Explicitly constrain the maximum width for portrait mode

                Spacer()
            }
            .padding()
        }
        .onAppear {
            // Fetch the latest custom goals when the view appears
            loadCustomGoals()
        }
    }

    // MARK: - Helper Functions

    /// Fetches the custom goals from Core Data
    private func loadCustomGoals() {
        customGoals = coreDataViewModel.fetchCustomGoals()
    }

    /// Creates a progress row for a specific goal
    private func goalProgressRow(for goal: Goal) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Display progress bar and current goal progress
            HStack {
                ProgressView(goal.name ?? "Unnamed Goal", value: Double(goal.progress), total: Double(goal.target))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text("\(goal.progress)/\(goal.target)")
                    .font(.caption)
                    .foregroundColor(.black)
            }

            // Goal row with increment functionality
            GoalRow(
                goalTitle: goal.name ?? "Unnamed Goal",
                progress: "\(goal.progress)",
                goal: "\(goal.target)",
                isCompleted: goal.progress >= goal.target,
                incrementAction: {
                    if goal.progress < goal.target {
                        coreDataViewModel.updateGoalProgress(goal, progress: goal.progress + 1)
                        loadCustomGoals() // Refresh goals after updating progress
                    }
                }
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    CustomGoalsDetailView(coreDataViewModel: CoreDataViewModel())
}
