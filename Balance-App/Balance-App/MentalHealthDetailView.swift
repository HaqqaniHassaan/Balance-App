import SwiftUI

struct MentalHealthDetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Today's Mental Health")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // Progress Summary
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    ProgressView("Meditation", value: 20, total: 60)
                        .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                    Text("20/60 MIN")
                        .font(.caption)
                }
                
                HStack {
                    ProgressView("Mindful Breaks", value: 5, total: 10)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    Text("5/10 Breaks")
                        .font(.caption)
                }
                
                HStack {
                    ProgressView("Outdoor Time", value: 30, total: 60)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    Text("30/60 MIN")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(15)
            .shadow(radius: 5)
            
            // Goals Overview
            VStack(alignment: .leading, spacing: 10) {
                Text("Goals")
                    .font(.title2)
                    .bold()
                
                GoalRow(goalTitle: "Daily Meditation", progress: "20 min", goal: "60 min")
                GoalRow(goalTitle: "Fresh Air", progress: "30 min", goal: "60 min")
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MentalHealthDetailView()
}
