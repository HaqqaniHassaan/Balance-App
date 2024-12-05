import SwiftUI

struct MentalHealthDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // State variables for progress tracking
    @State var meditationMinutes = 0
    @State var outdoorMinutes = 0
    @State var familyCallMinutes = 0
    @State var mindfulBreathingMinutes = 0
    @State var screenOffMinutes = 0

    // State variables for streaks
    @State var meditationCurrentStreak = 0
    @State var meditationLongestStreak = 0
    @State var outdoorCurrentStreak = 0
    @State var outdoorLongestStreak = 0
    @State var familyCallCurrentStreak = 0
    @State var familyCallLongestStreak = 0
    @State var mindfulBreathingCurrentStreak = 0
    @State var mindfulBreathingLongestStreak = 0
    @State var screenOffCurrentStreak = 0
    @State var screenOffLongestStreak = 0

    // Timer-related states for meditation
    @State var isMeditationActive = false
    @State var meditationTimer: Timer?

    // Goals for each tracked metric
    let meditationGoal = 60
    let outdoorGoal = 60
    let familyCallGoal = 30
    let mindfulBreathingGoal = 20
    let screenOffGoal = 90

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                // Title
                Text("Today's Mental Health")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                    .padding(.top)

                // Summary Widget
                progressSummaryWidget

                // Goals Overview
                VStack(spacing: 20) {
                    // Meditation Goal
                    if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                        GoalRow(
                            goalTitle: "Meditation",
                            progress: meditationMinutes,
                            goal: meditationGoal,
                            isCompleted: meditationMinutes >= meditationGoal,
                            isCheckable: true,
                            currentStreak: meditationCurrentStreak,
                            longestStreak: meditationLongestStreak
                        ) { updatedProgress in
                            meditationMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.meditationMinutes, value: Int64(meditationMinutes))

                            // Update streaks
                            coreDataViewModel.updateEntityStreaks(
                                entity: coreDataViewModel.mentalHealthEntity!,
                                streakKey: "meditation",
                                didComplete: meditationMinutes >= meditationGoal
                            )
                            loadStreaks()
                        }
                    }

                    // Fresh Air Goal
                    if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                        GoalRow(
                            goalTitle: "Fresh Air",
                            progress: outdoorMinutes,
                            goal: outdoorGoal,
                            isCompleted: outdoorMinutes >= outdoorGoal,
                            isCheckable: true,
                            currentStreak: outdoorCurrentStreak,
                            longestStreak: outdoorLongestStreak
                        ) { updatedProgress in
                            outdoorMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.outdoorMinutes, value: Int64(outdoorMinutes))

                            // Update streaks
                            coreDataViewModel.updateEntityStreaks(
                                entity: coreDataViewModel.mentalHealthEntity!,
                                streakKey: "outdoorTime",
                                didComplete: outdoorMinutes >= outdoorGoal
                            )
                            loadStreaks()
                        }
                    }

                    // Family Calls Goal
                    if coreDataViewModel.mentalHealthEntity?.isFamilyCallTracked == true {
                        GoalRow(
                            goalTitle: "Family Calls",
                            progress: familyCallMinutes,
                            goal: familyCallGoal,
                            isCompleted: familyCallMinutes >= familyCallGoal,
                            isCheckable: true,
                            currentStreak: familyCallCurrentStreak,
                            longestStreak: familyCallLongestStreak
                        ) { updatedProgress in
                            familyCallMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.familyCallMinutes, value: Int64(familyCallMinutes))

                            // Update streaks
                            coreDataViewModel.updateEntityStreaks(
                                entity: coreDataViewModel.mentalHealthEntity!,
                                streakKey: "familyCalls",
                                didComplete: familyCallMinutes >= familyCallGoal
                            )
                            loadStreaks()
                        }
                    }

                    // Mindful Breathing Goal
                    if coreDataViewModel.mentalHealthEntity?.isMindfulBreathingTracked == true {
                        GoalRow(
                            goalTitle: "Mindful Breathing",
                            progress: mindfulBreathingMinutes,
                            goal: mindfulBreathingGoal,
                            isCompleted: mindfulBreathingMinutes >= mindfulBreathingGoal,
                            isCheckable: true,
                            currentStreak: mindfulBreathingCurrentStreak,
                            longestStreak: mindfulBreathingLongestStreak
                        ) { updatedProgress in
                            mindfulBreathingMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.mindfulBreathingMinutes, value: Int64(mindfulBreathingMinutes))

                            // Update streaks
                            coreDataViewModel.updateEntityStreaks(
                                entity: coreDataViewModel.mentalHealthEntity!,
                                streakKey: "mindfulBreathing",
                                didComplete: mindfulBreathingMinutes >= mindfulBreathingGoal
                            )
                            loadStreaks()
                        }
                    }

                    // Screen-Off Time Goal
                    if coreDataViewModel.mentalHealthEntity?.isScreenOffTracked == true {
                        GoalRow(
                            goalTitle: "Screen-Off Time",
                            progress: screenOffMinutes,
                            goal: screenOffGoal,
                            isCompleted: screenOffMinutes >= screenOffGoal,
                            isCheckable: true,
                            currentStreak: screenOffCurrentStreak,
                            longestStreak: screenOffLongestStreak
                        ) { updatedProgress in
                            screenOffMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.screenOffMinutes, value: Int64(screenOffMinutes))

                            // Update streaks
                            coreDataViewModel.updateEntityStreaks(
                                entity: coreDataViewModel.mentalHealthEntity!,
                                streakKey: "screenOff",
                                didComplete: screenOffMinutes >= screenOffGoal
                            )
                            loadStreaks()
                        }
                    }
                }
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
            loadSavedData()
            loadStreaks()
        }
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - Progress Summary Widget
    var progressSummaryWidget: some View {
        let totalProgress = calculateTotalProgress()
        return VStack(spacing: 5) {
            Text("Overall Progress")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)

            ProgressView(value: totalProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                .frame(height: 10)
                .background(Color(UIColor.systemGray5).opacity(0.8))
                .cornerRadius(5)

            Text("\(Int(totalProgress * 100))% completed")
                .font(.caption)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
        }
        .padding()
        .background(Color(UIColor.systemGray6).opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 3)
    }

    // MARK: - Calculate Total Progress
    func calculateTotalProgress() -> Double {
        let goals = [
            (Double(meditationMinutes) / Double(meditationGoal)),
            (Double(outdoorMinutes) / Double(outdoorGoal)),
            (Double(familyCallMinutes) / Double(familyCallGoal)),
            (Double(mindfulBreathingMinutes) / Double(mindfulBreathingGoal)),
            (Double(screenOffMinutes) / Double(screenOffGoal))
        ]
        let validGoals = goals.filter { $0 > 0 }
        let averageProgress = validGoals.isEmpty ? 0.0 : validGoals.reduce(0.0, +) / Double(validGoals.count)
        return min(averageProgress, 1.0)
    }

    // MARK: - Load Streaks
    private func loadStreaks() {
        if let streaks = coreDataViewModel.fetchStreaks(forEntity: .mentalHealth, streakKey: "meditation") {
            meditationCurrentStreak = streaks.current
            meditationLongestStreak = streaks.longest
        }
        if let streaks = coreDataViewModel.fetchStreaks(forEntity: .mentalHealth, streakKey: "outdoorTime") {
            outdoorCurrentStreak = streaks.current
            outdoorLongestStreak = streaks.longest
        }
        if let streaks = coreDataViewModel.fetchStreaks(forEntity: .mentalHealth, streakKey: "familyCalls") {
            familyCallCurrentStreak = streaks.current
            familyCallLongestStreak = streaks.longest
        }
        if let streaks = coreDataViewModel.fetchStreaks(forEntity: .mentalHealth, streakKey: "mindfulBreathing") {
            mindfulBreathingCurrentStreak = streaks.current
            mindfulBreathingLongestStreak = streaks.longest
        }
        if let streaks = coreDataViewModel.fetchStreaks(forEntity: .mentalHealth, streakKey: "screenOff") {
            screenOffCurrentStreak = streaks.current
            screenOffLongestStreak = streaks.longest
        }
    }

    // MARK: - Load Saved Data
    private func loadSavedData() {
        if let savedMeditationMinutes = coreDataViewModel.mentalHealthEntity?.meditationMinutes {
            meditationMinutes = Int(savedMeditationMinutes)
        }
        if let savedOutdoorMinutes = coreDataViewModel.mentalHealthEntity?.outdoorMinutes {
            outdoorMinutes = Int(savedOutdoorMinutes)
        }
        if let savedFamilyCallMinutes = coreDataViewModel.mentalHealthEntity?.familyCallMinutes {
            familyCallMinutes = Int(savedFamilyCallMinutes)
        }
        if let savedMindfulBreathingMinutes = coreDataViewModel.mentalHealthEntity?.mindfulBreathingMinutes {
            mindfulBreathingMinutes = Int(savedMindfulBreathingMinutes)
        }
        if let savedScreenOffMinutes = coreDataViewModel.mentalHealthEntity?.screenOffMinutes {
            screenOffMinutes = Int(savedScreenOffMinutes)
        }
    }
}

#Preview {
    MentalHealthDetailView(coreDataViewModel: CoreDataViewModel())
}
