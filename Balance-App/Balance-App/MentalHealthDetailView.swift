import SwiftUI

struct MentalHealthDetailView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var meditationMinutes = 0
    @State private var outdoorMinutes = 0

    private let meditationGoal = 60
    private let outdoorGoal = 60

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
                        .shadow(color: .black, radius: 0.05, x: 0, y: 2)
                        .padding(.top, 20) // Add padding for better spacing

                    // Progress Summary
                    VStack(alignment: .leading, spacing: 15) {
                        if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                            HStack {
                                ProgressView("Meditation", value: Double(meditationMinutes), total: Double(meditationGoal))
                                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure alignment
                                Text("\(meditationMinutes)/\(meditationGoal) MIN")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }

                        if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                            HStack {
                                ProgressView("Outdoor Time", value: Double(outdoorMinutes), total: Double(outdoorGoal))
                                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure alignment
                                Text("\(outdoorMinutes)/\(outdoorGoal) MIN")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.8))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .frame(maxWidth: 350) // Constrain the width for better visual balance

                    // Goals Overview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Goals")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0.05, x: 0, y: 1)

                        if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                            GoalRow(
                                goalTitle: "Daily Meditation",
                                progress: "\(meditationMinutes) min",
                                goal: "\(meditationGoal) min",
                                isCompleted: meditationMinutes >= meditationGoal,
                                isCheckable: false, // Incrementable goal
                                action: {
                                    if meditationMinutes < meditationGoal {
                                        meditationMinutes += 1
                                        coreDataViewModel.updateMentalHealthMetric(for: \.meditationMinutes, value: Int64(meditationMinutes))
                                    }
                                }
                            )
                        }

                        if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                            GoalRow(
                                goalTitle: "Fresh Air",
                                progress: "\(outdoorMinutes) min",
                                goal: "\(outdoorGoal) min",
                                isCompleted: outdoorMinutes >= outdoorGoal,
                                isCheckable: true // Checkable goal
                            ) {
                                outdoorMinutes = outdoorGoal + 1 // Mark as completed
                                coreDataViewModel.updateMentalHealthMetric(for: \.outdoorMinutes, value: Int64(outdoorMinutes))
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6).opacity(0.8))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .frame(maxWidth: 350) // Constrain the width
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
    }
}
