import SwiftUI

struct FitnessDetailView: View {
    var body: some View {
        ZStack {
            Image("background_image")
                 .resizable()
                 .scaledToFill()
                 .frame(minWidth: 0) // 👈 This will keep other views (like a large text) in the frame
                 .ignoresSafeArea()
            VStack(spacing: 20) {
                // Title
                Text("Today's Fitness")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: 0, y: 2)
                
                
                // Progress Summary
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        ProgressView("Move", value: 300, total: 600)
                            .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        Text("300/600 CAL")
                            .font(.caption)
                    }
                    
                    HStack {
                        ProgressView("Exercise", value: 15, total: 30)
                            .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        Text("15/30 MIN")
                            .font(.caption)
                    }
                    
                    HStack {
                        ProgressView("Stand", value: 5, total: 12)
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        Text("5/12 HRS")
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
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 0.1, x: 0, y: 1)
                    
                    GoalRow(goalTitle: "Daily Steps", progress: "2,000 steps", goal: "5,000 steps")
                    GoalRow(goalTitle: "Drink Water", progress: "1 gallon", goal: "4 gallons")
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct GoalRow: View {
    var goalTitle: String
    var progress: String
    var goal: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                Text("\(progress) / \(goal)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

#Preview{
    
    FitnessDetailView()
}
