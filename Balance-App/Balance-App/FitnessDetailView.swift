import SwiftUI

struct FitnessDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @State private var stepsWalked: Int = 0
    @State private var caloriesBurned: Int = 0
    @State private var exerciseMinutes: Int = 0
    @State private var waterIntake: Int = 0
    @State private var stretchingMinutes: Int = 0

    // Placeholder goals
    private let stepGoal = 10000
    private let calorieGoal = 600
    private let exerciseGoal = 30
    private let waterGoal = 4 // 4 gallons
    private let stretchingGoal = 15 // 15 minutes

    var body: some View {
        ZStack {
            Image("background_image")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text("Today's Fitness")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: 0, y: 2)

                // Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    // Steps tracking
                    if coreDataViewModel.fitnessEntity?.isStepsTracked == true {
                        HStack {
                            ProgressView("Daily Steps", value: Double(stepsWalked), total: Double(stepGoal))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            Text("\(stepsWalked)/\(stepGoal) steps")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }

                    // Calories tracking
                    if coreDataViewModel.fitnessEntity?.isCaloriesTracked == true {
                        HStack {
                            ProgressView("Calories Burned", value: Double(caloriesBurned), total: Double(calorieGoal))
                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                            Text("\(caloriesBurned)/\(calorieGoal) CAL")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }

                    // Exercise tracking
                    if coreDataViewModel.fitnessEntity?.isWorkoutTracked == true {
                        HStack {
                            ProgressView("Exercise Time", value: Double(exerciseMinutes), total: Double(exerciseGoal))
                                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                            Text("\(exerciseMinutes)/\(exerciseGoal) MIN")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
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

                    if coreDataViewModel.fitnessEntity?.isWaterTracked == true {
                        GoalRow(goalTitle: "Water Intake", progress: "\(waterIntake) gallons", goal: "\(waterGoal) gallons")
                    }

                    if coreDataViewModel.fitnessEntity?.isStretchingTracked == true {
                        GoalRow(goalTitle: "Stretching", progress: "\(stretchingMinutes) min", goal: "\(stretchingGoal) min")
                    }
                }
                .padding()

                Spacer()
            }
            .padding()
            .onAppear {
                // Fetch initial HealthKit data
                fetchHealthData()
            }
        }
    }

    // MARK: - Fetch Health Data
    private func fetchHealthData() {
        // Fetch step count
        HealthKitManager.shared.fetchStepCount { steps, error in
            DispatchQueue.main.async {
                if let steps = steps {
                    self.stepsWalked = Int(steps)
                } else {
                    print("Error fetching steps: \(String(describing: error))")
                }
            }
        }

        // Fetch active energy burned
        HealthKitManager.shared.fetchActiveEnergyBurned { calories, error in
            DispatchQueue.main.async {
                if let calories = calories {
                    self.caloriesBurned = Int(calories)
                } else {
                    print("Error fetching calories burned: \(String(describing: error))")
                }
            }
        }

        // Fetch exercise time
        HealthKitManager.shared.fetchExerciseTime { exerciseTime, error in
            DispatchQueue.main.async {
                if let exerciseTime = exerciseTime {
                    self.exerciseMinutes = Int(exerciseTime)
                } else {
                    print("Error fetching exercise time: \(String(describing: error))")
                }
            }
        }
    }
}

// MARK: - Goal Row Component
struct GoalRow: View {
    var goalTitle: String
    var progress: String
    var goal: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                    .foregroundColor(.black)
                Text("\(progress) / \(goal)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color(UIColor.systemGray6).opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

#Preview {
    FitnessDetailView(coreDataViewModel: CoreDataViewModel())
}
