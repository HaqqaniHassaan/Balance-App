import SwiftUI

struct MentalHealthDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // State variables for progress tracking
    @State private var meditationMinutes = 0
    @State private var outdoorMinutes = 0
    @State private var familyCallMinutes = 0
    @State private var mindfulBreathingMinutes = 0
    @State private var screenOffMinutes = 0

    // Timer-related states for meditation
    @State private var isMeditationActive = false
    @State private var meditationTimer: Timer?

    // Goals for each tracked metric
    private let meditationGoal = 60
    private let outdoorGoal = 60
    private let familyCallGoal = 30
    private let mindfulBreathingGoal = 20
    private let screenOffGoal = 90

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

                // Goals Overview
                VStack(spacing: 20) {
                    // Daily Meditation Goal Row
                    if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                        meditationGoalRow
                    }

                    // Other Goals
                    if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                        GoalRow(
                            goalTitle: "Fresh Air",
                            progress: outdoorMinutes,
                            goal: outdoorGoal,
                            isCompleted: outdoorMinutes >= outdoorGoal,
                            isCheckable: true
                        ) { updatedProgress in
                            outdoorMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.outdoorMinutes, value: Int64(outdoorMinutes))
                        }
                    }

                    if coreDataViewModel.mentalHealthEntity?.isFamilyCallTracked == true {
                        GoalRow(
                            goalTitle: "Family Calls",
                            progress: familyCallMinutes,
                            goal: familyCallGoal,
                            isCompleted: familyCallMinutes >= familyCallGoal,
                            isCheckable: true
                        ) { updatedProgress in
                            familyCallMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.familyCallMinutes, value: Int64(familyCallMinutes))
                        }
                    }

                    if coreDataViewModel.mentalHealthEntity?.isMindfulBreathingTracked == true {
                        GoalRow(
                            goalTitle: "Mindful Breathing",
                            progress: mindfulBreathingMinutes,
                            goal: mindfulBreathingGoal,
                            isCompleted: mindfulBreathingMinutes >= mindfulBreathingGoal,
                            isCheckable: true
                        ) { updatedProgress in
                            mindfulBreathingMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.mindfulBreathingMinutes, value: Int64(mindfulBreathingMinutes))
                        }
                    }

                    if coreDataViewModel.mentalHealthEntity?.isScreenOffTracked == true {
                        GoalRow(
                            goalTitle: "Screen-Off Time",
                            progress: screenOffMinutes,
                            goal: screenOffGoal,
                            isCompleted: screenOffMinutes >= screenOffGoal,
                            isCheckable: true
                        ) { updatedProgress in
                            screenOffMinutes = updatedProgress
                            coreDataViewModel.updateMentalHealthMetric(for: \.screenOffMinutes, value: Int64(screenOffMinutes))
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
        }
    }

    // MARK: - Meditation Goal Row
    // Meditation Goal Row
    private var meditationGoalRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Daily Meditation")
                    .font(.headline)
                    .foregroundColor(.black)

                Text("Meditated: \(meditationMinutes) mins")
                    .font(.caption)
                    .foregroundColor(.gray)

                ProgressView(value: Double(meditationMinutes) / Double(meditationGoal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
            }

            Spacer()

            // Play/Pause Button
            Button(action: toggleMeditation) {
                Image(systemName: isMeditationActive ? "pause.circle.fill" : "play.circle.fill")
                    .foregroundColor(isMeditationActive ? .red : .green)
                    .font(.title2)
            }
        }
        .padding()
        .frame(maxWidth: 300, minHeight: 60) // Match the height and width of GoalRow
        .background(Color(UIColor.systemGray6).opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 3)
    }



    // MARK: - Timer Functions
    private func toggleMeditation() {
        if isMeditationActive {
            stopMeditation()
        } else {
            startMeditation()
        }
    }

    private func startMeditation() {
        isMeditationActive = true
        meditationTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            meditationMinutes += 1
            coreDataViewModel.updateMentalHealthMetric(for: \.meditationMinutes, value: Int64(meditationMinutes))

            // Stop automatically if the goal is reached
            if meditationMinutes >= meditationGoal {
                stopMeditation()
            }
        }
    }

    private func stopMeditation() {
        isMeditationActive = false
        meditationTimer?.invalidate()
        meditationTimer = nil
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
