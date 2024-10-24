import SwiftUI

struct FitnessDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass // Detect orientation

    // Bind water intake and stretching minutes to Core Data
    @State private var waterIntake: Int = 0
    @State private var stretchingMinutes: Int = 0

    // State variables for HealthKit data
    @State private var stepsWalked: Int = 0
    @State private var caloriesBurned: Int = 0
    @State private var exerciseMinutes: Int = 0

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

            if verticalSizeClass == .regular {
                // Portrait Mode
                VStack(spacing: 20) {
                    contentTitle

                    healthKitProgressSummary
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.8))
                        .cornerRadius(15)
                        .shadow(radius: 5)

                    goalsOverview
                        .padding()

                    Spacer()
                }
                .padding()
            } else {
                // Landscape Mode
                VStack {
                    
                    contentTitle
                        .frame(maxWidth: .infinity, alignment: .center) // Center align in landscape
                        .padding()
                    HStack( spacing: 20) {
                        healthKitProgressSummary
                            .padding()
                        
                            .background(Color(UIColor.systemGray6).opacity(0.8))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        
                        goalsOverview
                            .padding()
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            // Load saved data from Core Data
            loadSavedData()

            // Fetch initial HealthKit data
            fetchHealthData()
        }
    }

    // MARK: - Components

    // Title
    private var contentTitle: some View {
        Text("Today's Fitness")
            .font(.largeTitle)
            .bold()
            .padding(.top)
            .foregroundColor(.white)
            .shadow(color: .black, radius: 0.1, x: 0, y: 2)
    }

    // HealthKit Progress Summary
    private var healthKitProgressSummary: some View {
        VStack(alignment: .leading, spacing: 15) {
            if coreDataViewModel.fitnessEntity?.isStepsTracked == true {
                HStack {
                    ProgressView("Daily Steps", value: Double(stepsWalked), total: Double(stepGoal))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    Text("\(stepsWalked)/\(stepGoal) steps")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }

            if coreDataViewModel.fitnessEntity?.isCaloriesTracked == true {
                HStack {
                    ProgressView("Calories Burned", value: Double(caloriesBurned), total: Double(calorieGoal))
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    Text("\(caloriesBurned)/\(calorieGoal) CAL")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }

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
    }

    // Goals Overview
    private var goalsOverview: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Goals")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.1, x: 0, y: 1)

            if coreDataViewModel.fitnessEntity?.isWaterTracked == true {
                GoalRow(
                    goalTitle: "Water Intake",
                    progress: "\(waterIntake) gallons",
                    goal: "\(waterGoal) gallons",
                    isCompleted: waterIntake >= waterGoal
                ) {
                    // Increment water intake and update Core Data
                    if waterIntake < waterGoal {
                        waterIntake += 1
                        coreDataViewModel.updateWaterIntake(waterIntake)
                    }
                }
            }

            if coreDataViewModel.fitnessEntity?.isStretchingTracked == true {
                GoalRow(
                    goalTitle: "Stretching",
                    progress: "\(stretchingMinutes) min",
                    goal: "\(stretchingGoal) min",
                    isCompleted: stretchingMinutes >= stretchingGoal
                ) {
                    // Increment stretching minutes and update Core Data
                    if stretchingMinutes < stretchingGoal {
                        stretchingMinutes += 1
                        coreDataViewModel.updateStretchingMinutes(stretchingMinutes)
                    }
                }
            }
        }
    }

    // MARK: - Load Saved Data
    private func loadSavedData() {
        if let savedWaterIntake = coreDataViewModel.fitnessEntity?.waterIntake {
            waterIntake = Int(savedWaterIntake)
        }
        if let savedStretchingMinutes = coreDataViewModel.fitnessEntity?.stretchingMinutes {
            stretchingMinutes = Int(savedStretchingMinutes)
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

#Preview {
    FitnessDetailView(coreDataViewModel: CoreDataViewModel())
}
