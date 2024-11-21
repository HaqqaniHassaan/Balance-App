//
//  GoalRow.swift
//  Balance-App
//
//  Created by user264048 on 10/23/24.
//

import SwiftUI

struct GoalRow: View {
    var goalTitle: String
    var progress: String
    var goal: String
    var isCompleted: Bool
    var isCheckable: Bool // New parameter to distinguish between checkable and incrementable goals
    var action: () -> Void // Generalized action for either incrementing or checking

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                    .foregroundColor(isCompleted ? .white : .black)
                Text(isCheckable ? "Check the box if you've completed this goal." : "\(progress) / \(goal)") // Show progress only for incrementable goals
                    .font(.caption)
                    .foregroundColor(isCompleted ? .white : .gray)
            }

            Spacer()

            // Checkable or Increment Button
            if isCheckable {
                Button(action: action) {
                    Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                        .foregroundColor(isCompleted ? .white : .blue)
                        .font(.title2)
                }
            } else {
                Button(action: action) {
                    if isCompleted{
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    else{
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, minHeight: 60)
        .background(
            Color(isCompleted ? UIColor.systemYellow : UIColor.systemGray6)
                .opacity(0.8)
                .animation(.easeInOut, value: isCompleted)
        )
        .cornerRadius(10)
        .shadow(radius: isCompleted ? 5 : 3)
    }
}
