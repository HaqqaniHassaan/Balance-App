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
    var isCheckable: Bool // Distinguishes between checkable and incrementable goals
    var action: (Bool) -> Void // Passes the toggle state (checked or unchecked) to the parent view

    @State private var isChecked: Bool = false // Local state to manage the checkable state

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                    .foregroundColor(isChecked ? .white : .black)
                Text(isCheckable ? "Check the box if you've completed this goal." : "\(progress) / \(goal)") // Show progress only for incrementable goals
                    .font(.caption)
                    .foregroundColor(isChecked ? .white : .gray)
            }

            Spacer()

            // Checkable or Increment Button
            if isCheckable {
                Button(action: {
                    isChecked.toggle() // Toggle the check state
                    action(isChecked) // Pass the new state to the parent
                }) {
                    Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        .foregroundColor(isChecked ? .white : .blue)
                        .font(.title2)
                }
            } else {
                Button(action: {
                    action(true) // Always increment for non-checkable goals
                }) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "plus.circle.fill")
                        .foregroundColor(isCompleted ? .white : .blue)
                        .font(.title2)
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, minHeight: 60)
        .background(
            Color(isChecked || isCompleted ? UIColor.systemYellow : UIColor.systemGray6)
                .opacity(0.8)
                .animation(.easeInOut, value: isChecked || isCompleted)
        )
        .cornerRadius(10)
        .shadow(radius: isChecked || isCompleted ? 5 : 3)
    }
}
