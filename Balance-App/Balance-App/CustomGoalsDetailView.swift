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

            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    CustomGoalsTitleView()

                    // Goals Overview
                    GoalsOverviewView(
                        customGoals: customGoals,
                        coreDataViewModel: coreDataViewModel,
                        onUpdateGoals: loadCustomGoals
                    )
                }
                .padding()
                .frame(maxWidth: .infinity) // Center the content
            }
        }
        .onAppear {
            loadCustomGoals()
        }
    }

    // MARK: - Helper Functions
    /// Fetches the custom goals from Core Data
    private func loadCustomGoals() {
        customGoals = coreDataViewModel.fetchCustomGoals()
    }
}

// MARK: - Subviews

/// Title View
struct CustomGoalsTitleView: View {
    var body: some View {
        Text("Today's Custom Goals")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
            .padding(.top, 20)
    }
}

/// Goals Overview View
struct GoalsOverviewView: View {
    let customGoals: [Goal]
    let coreDataViewModel: CoreDataViewModel
    let onUpdateGoals: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Goals")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)


            ForEach(customGoals, id: \.self) { goal in
                GoalRow(
                    goalTitle: goal.name ?? "Unnamed Goal",
                    progress: "\(goal.progress)",
                    goal: "\(goal.target)",
                    isCompleted: goal.progress >= goal.target,
                    isCheckable: goal.isCheckable
                ) {_ in 
                    if goal.isCheckable {
                        // Mark goal as completed by setting progress to target
                        coreDataViewModel.updateGoalProgress(goal, progress: goal.target)
                    } else {
                        // Increment progress for incrementable goals
                        if goal.progress < goal.target {
                            coreDataViewModel.updateGoalProgress(goal, progress: goal.progress + 1)
                        }
                    }
                    onUpdateGoals() // Refresh goals after updating progress
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 5)
        .frame(maxWidth: 350) // Constrain the width
    }
}

#Preview {
    CustomGoalsDetailView(coreDataViewModel: CoreDataViewModel())
}
