import SwiftUI

struct CustomGoalsDetailView: View {
    // Inject the CoreDataViewModel instance
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    var body: some View {
        ZStack {
            // Background image
            Image("background_image")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Title
                Text("Today's Custom Goals")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: 0, y: 2)

                // Placeholder Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    ProgressView("Reading", value: 30, total: 60) // Placeholder values
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    Text("30/60 MIN")
                        .font(.caption)
                        .foregroundColor(.white)

                    ProgressView("Learning", value: 1, total: 2) // Placeholder values
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    Text("1/2 Tasks")
                        .font(.caption)
                        .foregroundColor(.white)

                    ProgressView("Cooking", value: 1, total: 3) // Placeholder values
                        .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                    Text("1/3 Meals")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(UIColor.systemGray6).opacity(0.8))
                .cornerRadius(15)
                .shadow(radius: 5)

                // Placeholder Goals Overview
                VStack(alignment: .leading, spacing: 10) {
                    Text("Goals")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0.1, x: 0, y: 1)

                    GoalRow(goalTitle: "Daily Reading", progress: "30 min", goal: "60 min")
                    GoalRow(goalTitle: "Learning Sessions", progress: "1 task", goal: "2 tasks")
                    GoalRow(goalTitle: "Cooking Meals", progress: "1 meal", goal: "3 meals")
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}

// Preview for CustomGoalsDetailView
struct CustomGoalsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CustomGoalsDetailView(coreDataViewModel: CoreDataViewModel())
    }
}
