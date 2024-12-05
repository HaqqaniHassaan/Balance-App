import SwiftUI

struct MentalHealthDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // State variables for progress tracking
    @State   var meditationMinutes = 0
    @State   var outdoorMinutes = 0
    @State   var familyCallMinutes = 0
    @State   var mindfulBreathingMinutes = 0
    @State   var screenOffMinutes = 0

    // Timer-related states for meditation
    @State   var isMeditationActive = false
    @State   var meditationTimer: Timer?

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
                            DispatchQueue.main.async {
                                outdoorMinutes = updatedProgress
                                coreDataViewModel.updateMentalHealthMetric(for: \.outdoorMinutes, value: Int64(outdoorMinutes))
                            }
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
        .navigationBarBackButtonHidden(false) // Ensure back button is shown

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


    // MARK: - Meditation Goal Row
     var meditationGoalRow: some View {
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
      func toggleMeditation() {
        if isMeditationActive {
            stopMeditation()
        } else {
            startMeditation()
        }
    }

      func startMeditation() {
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

      func stopMeditation() {
        isMeditationActive = false
        meditationTimer?.invalidate()
        meditationTimer = nil
    }

    // MARK: - Load Saved Data
      func loadSavedData() {
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
