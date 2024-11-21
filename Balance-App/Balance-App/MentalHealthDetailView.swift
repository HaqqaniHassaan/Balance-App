import SwiftUI

struct MentalHealthDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // State variables for progress tracking
    @State private var meditationMinutes = 0
    @State private var outdoorMinutes = 0
    @State private var familyCallMinutes = 0
    @State private var mindfulBreathingMinutes = 0
    @State private var screenOffMinutes = 0

    // Goals for each tracked metric
    private let meditationGoal = 60
    private let outdoorGoal = 60
    private let familyCallGoal = 30
    private let mindfulBreathingGoal = 20
    private let screenOffGoal = 90

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
                    Text("Today's Mental Health")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                        .padding(.top, 20)

                    // Goals Overview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Goals")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 1, x: 0, y: 1)

                        if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                            GoalRow(
                                goalTitle: "Daily Meditation",
                                progress: meditationMinutes,
                                goal: meditationGoal,
                                isCompleted: meditationMinutes >= meditationGoal,
                                isCheckable: false
                            ) { updatedProgress in
                                meditationMinutes = updatedProgress
                                coreDataViewModel.updateMentalHealthMetric(for: \.meditationMinutes, value: Int64(meditationMinutes))
                            }
                        }

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
                    .frame(maxWidth: 450) // Constrain the width
                }
                .padding()
                .frame(maxWidth: .infinity) // Center the content
            }
        }
        .onAppear {
            loadSavedData()
        }
    }

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
