import SwiftUI
import CoreData

struct CustomGoalsDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var customGoals: [Goal] = [] // Custom goals fetched from Core Data
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
                VStack(spacing: 20) {
                    // Title
                    CustomGoalsTitleView()

                    // Goals Overview
                    GoalsOverviewView(
                        customGoals: customGoals,
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
    /// Fetches the custom goals from Core Data
    private func loadCustomGoals() {
        customGoals = coreDataViewModel.fetchCustomGoals()
    }
}

// MARK: - Goals Overview View
struct GoalsOverviewView: View {
    let customGoals: [Goal]
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
                    // Handle optional properties with default values
                    GoalRow(
                        goalTitle: goal.name ?? "Unnamed Goal",
                        progress: Int(goal.progress),
                        goal: Int(goal.target),
                        isCompleted: goal.progress >= goal.target,
                        isCheckable: goal.isCheckable
                    ) { updatedProgress in
                        // Update progress and refresh the view
                        coreDataViewModel.updateGoalProgress(goal, progress: Int64(updatedProgress))
                        onUpdateGoals()
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

// MARK: - Add Goal View
struct AddGoalView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.dismiss) var dismiss

    @State private var goalName = ""
    @State private var targetValue: String = ""
    @State private var isCheckable = false

    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Name", text: $goalName)
                        .autocapitalization(.words)
                    TextField("Target Value", text: $targetValue)
                        .keyboardType(.numberPad)
                    Toggle("Checkable Goal", isOn: $isCheckable)
                }
            }
            .navigationBarTitle("Add New Goal", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                saveGoal()
            })
        }
    }

    private func saveGoal() {
        guard let target = Int64(targetValue), !goalName.isEmpty else {
            // Optionally, show an alert if validation fails
            return
        }
        coreDataViewModel.addCustomGoal(name: goalName, target: target, isCheckable: isCheckable)
        onSave()
        dismiss()
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
