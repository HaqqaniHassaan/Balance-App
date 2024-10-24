import SwiftUI

struct CustomGoalsDetailView: View {
    // Inject the CoreDataViewModel instance
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // Placeholder values for goals
    @State private var readingMinutes = 30
    @State private var learningTasks = 1
    @State private var cookingMeals = 1

    // Goal targets
    private let readingGoal = 60 // 60 minutes
    private let learningGoal = 2 // 2 tasks
    private let cookingGoal = 3 // 3 meals

    var body: some View {
        ZStack {
            // Background image
            Image("background_image")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text("Today's Custom Goals")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: 0, y: 2)

                // Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    // Reading Progress
                    HStack {
                        ProgressView("Reading", value: Double(readingMinutes), total: Double(readingGoal))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        Text("\(readingMinutes)/\(readingGoal) MIN")
                            .font(.caption)
                            .foregroundColor(.black)
                    }

                    // Learning Progress
                    HStack {
                        ProgressView("Learning", value: Double(learningTasks), total: Double(learningGoal))
                            .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        Text("\(learningTasks)/\(learningGoal) Tasks")
                            .font(.caption)
                            .foregroundColor(.black)
                    }

                    // Cooking Progress
                    HStack {
                        ProgressView("Cooking", value: Double(cookingMeals), total: Double(cookingGoal))
                            .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        Text("\(cookingMeals)/\(cookingGoal) Meals")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.8))
                .cornerRadius(15)
                .shadow(radius: 5)

                // Goals Overview
                VStack(alignment: .leading, spacing: 10) {
                    Text("Goals")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0.1, x: 0, y: 1)

                    // Goal Rows with manual increment functionality
                    GoalRow(
                        goalTitle: "Daily Reading",
                        progress: "\(readingMinutes) min",
                        goal: "\(readingGoal) min",
                        isCompleted: readingMinutes >= readingGoal,
                        incrementAction: {
                            // Increment reading minutes
                            if readingMinutes < readingGoal {
                                readingMinutes += 1
                            }
                        }
                    )

                    GoalRow(
                        goalTitle: "Learning Sessions",
                        progress: "\(learningTasks) task",
                        goal: "\(learningGoal) tasks",
                        isCompleted: learningTasks >= learningGoal,
                        incrementAction: {
                            // Increment learning tasks
                            if learningTasks < learningGoal {
                                learningTasks += 1
                            }
                        }
                    )

                    GoalRow(
                        goalTitle: "Cooking Meals",
                        progress: "\(cookingMeals) meal",
                        goal: "\(cookingGoal) meals",
                        isCompleted: cookingMeals >= cookingGoal,
                        incrementAction: {
                            // Increment cooking meals
                            if cookingMeals < cookingGoal {
                                cookingMeals += 1
                            }
                        }
                    )
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}

// Preview for CustomGoalsDetailView


#Preview {
    CustomGoalsDetailView(coreDataViewModel: CoreDataViewModel())

}
