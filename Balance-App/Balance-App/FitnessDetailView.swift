import SwiftUI

struct FitnessDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var stepsWalked: Int = 0
    @State private var caloriesBurned: Int = 0
    @State private var exerciseMinutes: Int = 0
    @State private var sleepMinutes: Int = 0
    @State private var waterIntake: Int = 0
    @State private var stretchingMinutes: Int = 0
    @State private var waterCurrentStreak: Int = 0
    @State private var waterLongestStreak: Int = 0

    // Goals
    private let calorieGoal = 2000 // Calories
    private let exerciseGoal = 30 // Exercise minutes
    private let sleepGoal = 480  // Sleep goal in minutes (8 hours)
    private let waterGoal = 4    // Water intake goal (in gallons)
    private let stretchingGoal = 15 // Stretching goal (in minutes)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                // Title
                Text("Today's Fitness")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                    .padding(.top)

                // Radial Progress View
                radialProgressView
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.8))
                    .cornerRadius(15)
                    .shadow(radius: 5)

                // Goals Overview (GoalRows)
                goalsOverview
                    .padding()
                    .cornerRadius(15)
                    .shadow(radius: 5)

                Spacer()
            }
            .padding()
        }
        .background(
            Image("background_image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onAppear {
            fetchHealthData()
            loadSavedData()
            loadStreaks()
        }
    }

    // MARK: - Radial Progress View
    private var radialProgressView: some View {
        HStack {
            Spacer()
            
            // Left Column with Metrics
            VStack(alignment: .leading, spacing: 12) {
                metricRow(title: "Calories", value: "\(caloriesBurned) kcal", color: .red)
                metricRow(title: "Activity", value: "\(exerciseMinutes) mins", color: .green)
                metricRow(title: "Sleep", value: "\(sleepMinutes / 60) hours", color: .blue)
            }
            Spacer()

            // Radial Progress Circle
            ZStack {
                // Calories Circle
                Circle()
                    .stroke(.red.opacity(0.3), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: min(Double(caloriesBurned) / Double(calorieGoal), 1.0))
                    .stroke(.red, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                // Active Time Circle
                Circle()
                    .stroke(.green.opacity(0.3), lineWidth: 15)
                    .padding(10)
                Circle()
                    .trim(from: 0, to: min(Double(exerciseMinutes) / Double(exerciseGoal), 1.0))
                    .stroke(.green, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(10)
                
                // Sleep Circle
                Circle()
                    .stroke(.blue.opacity(0.3), lineWidth: 10)
                    .padding(20)
                Circle()
                    .trim(from: 0, to: min(Double(sleepMinutes) / Double(sleepGoal), 1.0))
                    .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(20)
            }
            .frame(width: 150, height: 150) // Adjust size as needed
            
            Spacer()
        }
        .frame(maxWidth: 300, maxHeight: 200)
    }

    // MARK: - Metric Row
    private func metricRow(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundColor(color)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            Text(value)
                .bold()
        }
    }

    // MARK: - Goals Overview (GoalRows)
    private var goalsOverview: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Goals")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)

            // Checkable Goal: Water Intake
            if coreDataViewModel.fitnessEntity?.isWaterTracked == true {
                GoalRow(
                    goalTitle: "Water Intake",
                    progress: waterIntake,
                    goal: waterGoal,
                    isCompleted: waterIntake >= waterGoal,
                    isCheckable: true,
                    currentStreak: waterCurrentStreak,
                    longestStreak: waterLongestStreak
                ) { updatedProgress in
                    waterIntake = updatedProgress
                    coreDataViewModel.updateWaterIntake(waterIntake)

                    // Update streaks
                    coreDataViewModel.updateEntityStreaks(
                        entity: coreDataViewModel.fitnessEntity!,
                        streakKey: "waterIntake",
                        didComplete: waterIntake >= waterGoal
                    )
                    // Refresh streaks
                    loadStreaks()
                }
            }

            // Stretching Goal
            if coreDataViewModel.fitnessEntity?.isStretchingTracked == true {
                GoalRow(
                    goalTitle: "Stretching",
                    progress: stretchingMinutes,
                    goal: stretchingGoal,
                    isCompleted: stretchingMinutes >= stretchingGoal,
                    isCheckable: false
                ) { updatedProgress in
                    stretchingMinutes = updatedProgress
                    coreDataViewModel.updateStretchingMinutes(stretchingMinutes)
                }
            }
        }
    }

    // MARK: - Load Streaks
    private func loadStreaks() {
        if let streaks = coreDataViewModel.fetchStreaks(forEntity: .fitness, streakKey: "waterIntake") {
            waterCurrentStreak = streaks.current
            waterLongestStreak = streaks.longest
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
        HealthKitManager.shared.fetchStepCount { steps, _ in
            DispatchQueue.main.async {
                self.stepsWalked = Int(steps ?? 0)
            }
        }

        HealthKitManager.shared.fetchActiveEnergyBurned { calories, _ in
            DispatchQueue.main.async {
                self.caloriesBurned = Int(calories ?? 0)
            }
        }

        HealthKitManager.shared.fetchExerciseTime { exerciseTime, _ in
            DispatchQueue.main.async {
                self.exerciseMinutes = Int(exerciseTime ?? 0)
            }
        }

        HealthKitManager.shared.fetchSleepData { sleepTime, _ in
            DispatchQueue.main.async {
                self.sleepMinutes = Int(sleepTime ?? 0)
            }
        }
    }
}

#Preview {
    FitnessDetailView(coreDataViewModel: CoreDataViewModel())
}
