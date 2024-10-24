import SwiftUI

struct MentalHealthDetailView: View {
    // Inject the CoreDataViewModel instance as an observed object
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // Placeholder values for mental health tracking
    @State private var meditationMinutes = 20 // Placeholder
    @State private var outdoorMinutes = 30 // Placeholder

    // Goal targets
    private let meditationGoal = 60 // 60 minutes
    private let outdoorGoal = 60 // 60 minutes

    var body: some View {
        ZStack {
            // Background image
            Image("background_image")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Title
                Text("Today's Mental Health")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: 0, y: 2)

                // Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    // Meditation Tracking
                    if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                        HStack {
                            ProgressView("Meditation", value: Double(meditationMinutes), total: Double(meditationGoal))
                                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                            Text("\(meditationMinutes)/\(meditationGoal) MIN")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    // Outdoor Time Tracking
                    if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                        HStack {
                            ProgressView("Outdoor Time", value: Double(outdoorMinutes), total: Double(outdoorGoal))
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            Text("\(outdoorMinutes)/\(outdoorGoal) MIN")
                                .font(.caption)
                                .foregroundColor(.white)
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

                    // Meditation Goal
                    if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                        GoalRow(
                            goalTitle: "Daily Meditation",
                            progress: "\(meditationMinutes) min",
                            goal: "\(meditationGoal) min",
                            isCompleted: meditationMinutes >= meditationGoal,
                            incrementAction: {
                                // Increment meditation minutes
                                if meditationMinutes < meditationGoal {
                                    meditationMinutes += 1
                                }
                            }
                        )
                    }
                    
                    // Outdoor Time Goal
                    if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                        GoalRow(
                            goalTitle: "Fresh Air",
                            progress: "\(outdoorMinutes) min",
                            goal: "\(outdoorGoal) min",
                            isCompleted: outdoorMinutes >= outdoorGoal,
                            incrementAction: {
                                // Increment outdoor minutes
                                if outdoorMinutes < outdoorGoal {
                                    outdoorMinutes += 1
                                }
                            }
                        )
                    }
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}

// Preview for MentalHealthDetailView
struct MentalHealthDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MentalHealthDetailView(coreDataViewModel: CoreDataViewModel())
    }
}
