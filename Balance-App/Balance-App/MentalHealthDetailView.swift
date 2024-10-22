import SwiftUI

struct MentalHealthDetailView: View {
    // Inject the CoreDataViewModel instance as an observed object
    @ObservedObject var coreDataViewModel: CoreDataViewModel

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
                            ProgressView("Meditation", value: 20, total: 60) // Placeholder values
                                .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                            Text("20/60 MIN")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }

                    // Outdoor Time Tracking
                    if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                        HStack {
                            ProgressView("Outdoor Time", value: 30, total: 60) // Placeholder values
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            Text("30/60 MIN")
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

                    if coreDataViewModel.mentalHealthEntity?.isMeditationTracked == true {
                        GoalRow(goalTitle: "Daily Meditation", progress: "20 min", goal: "60 min") // Placeholder values
                    }
                    
                    if coreDataViewModel.mentalHealthEntity?.isOutdoorTimeTracked == true {
                        GoalRow(goalTitle: "Fresh Air", progress: "30 min", goal: "60 min") // Placeholder values
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
