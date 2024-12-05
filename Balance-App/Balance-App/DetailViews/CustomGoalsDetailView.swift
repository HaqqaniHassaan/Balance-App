import SwiftUI
import CoreData

struct CustomGoalsDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var customGoals: [Goal] = [] // Custom goals fetched from Core Data
    @State private var goalProgress: [NSManagedObjectID: Int] = [:] // Tracks progress for each goal
    @State private var isAddingGoal = false // Controls the sheet for adding a goal
    @State private var showDeleteButtonForGoal: NSManagedObjectID? = nil

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background image
            Image("background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // Title
                    CustomGoalsTitleView()

                    // Radial Progress Widget
                    radialProgressWidget

                    // Goals Overview
                    GoalsOverviewView(
                        customGoals: customGoals,
                        goalProgress: $goalProgress,
                        coreDataViewModel: coreDataViewModel,
                        onUpdateGoals: loadCustomGoals,
                        showDeleteButtonForGoal: $showDeleteButtonForGoal
                    )
                }
                .padding()
                .frame(maxWidth: .infinity) // Center the content
            }

            // Floating Action Button
            Button(action: {
                isAddingGoal = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 60)
                    .shadow(radius: 10)
            }
            .padding()
            .accessibilityLabel("Add New Goal")
            .sheet(isPresented: $isAddingGoal) {
                AddGoalView(coreDataViewModel: coreDataViewModel) {
                    loadCustomGoals()
                    isAddingGoal = false
                }
            }
        }
        .onAppear {
            loadCustomGoals()
        }
    }

    // MARK: - Helper Functions
    private func loadCustomGoals() {
        customGoals = coreDataViewModel.fetchCustomGoals()
        goalProgress = Dictionary(uniqueKeysWithValues: customGoals.map { ($0.objectID, Int($0.progress)) })
    }

    // MARK: - Radial Progress Widget
    private var radialProgressWidget: some View {
        let totalProgress = calculateTotalProgress()

        return ZStack {
            // Background Circle
            Circle()
                .stroke(Color(UIColor.systemGray5), lineWidth: 15)
                .frame(width: 150, height: 150)

            // Progress Circle
            Circle()
                .trim(from: 0, to: CGFloat(totalProgress))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 150, height: 150)

            // Center Text
            VStack {
                Text("\(Int(totalProgress * 100))%")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                Text("Completed")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    private func calculateTotalProgress() -> Double {
        guard !customGoals.isEmpty else { return 0.0 }
        let total = customGoals.reduce(0.0) { $0 + (Double(goalProgress[$1.objectID] ?? 0) / Double($1.target)) }
        return total / Double(customGoals.count)
    }
}

// MARK: - Goals Overview View
struct GoalsOverviewView: View {
    let customGoals: [Goal]
    @Binding var goalProgress: [NSManagedObjectID: Int]
    let coreDataViewModel: CoreDataViewModel
    let onUpdateGoals: () -> Void
    @Binding var showDeleteButtonForGoal: NSManagedObjectID?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Goals")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)

            ForEach(customGoals, id: \.self) { goal in
                HStack {
                    // Use progress from the binding
                    GoalRow(
                        goalTitle: goal.name ?? "Unnamed Goal",
                        progress: goalProgress[goal.objectID] ?? 0,
                        goal: Int(goal.target),
                        isCompleted: (goalProgress[goal.objectID] ?? 0) >= Int(goal.target),
                        isCheckable: goal.isCheckable
                    ) { updatedProgress in
                        // Update progress in local state and Core Data
                        goalProgress[goal.objectID] = updatedProgress
                        coreDataViewModel.updateGoalProgress(goal, progress: Int64(updatedProgress))
                    }
                    .onLongPressGesture {
                        // Toggle delete button visibility
                        if showDeleteButtonForGoal == goal.objectID {
                            showDeleteButtonForGoal = nil
                        } else {
                            showDeleteButtonForGoal = goal.objectID
                        }
                    }

                    // Delete Button (conditionally visible)
                    if showDeleteButtonForGoal == goal.objectID {
                        Button(action: {
                            coreDataViewModel.deleteGoal(goal)
                            onUpdateGoals()
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                        }
                        .accessibilityLabel("Delete Goal")
                    }
                }
            }
        }
        .padding()
        .cornerRadius(15)
        .shadow(radius: 5)
        .frame(maxWidth: 350)
    }
}

// MARK: - Title View
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

#Preview {
    CustomGoalsDetailView(coreDataViewModel: CoreDataViewModel())
}
