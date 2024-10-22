import SwiftUI

struct CustomGoalsDetailView: View {
    var body: some View {
        
        ZStack {
            Image("background_image")
                 .resizable()
                 .scaledToFill()
                 .frame(minWidth: 0) // 👈 This will keep other views (like a large text) in the frame
                 .ignoresSafeArea()
            VStack(spacing: 20) {
                // Title
                Text("Today's Custom Goals")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.white)
                
                // Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        ProgressView("Reading", value: 30, total: 60)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        Text("30/60 MIN")
                            .font(.caption)
                    }
                    
                    HStack {
                        ProgressView("Learning", value: 1, total: 2)
                            .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        Text("1/2 Tasks")
                            .font(.caption)
                    }
                    
                    HStack {
                        ProgressView("Cooking", value: 1, total: 3)
                            .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                        Text("1/3 Meals")
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


#Preview {
    CustomGoalsDetailView()
}
