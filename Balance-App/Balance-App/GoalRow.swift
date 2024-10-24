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
    var incrementAction: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goalTitle)
                    .font(.headline)
                    .foregroundColor(isCompleted ? .white : .black)
                Text("\(progress) / \(goal)")
                    .font(.caption)
                    .foregroundColor(isCompleted ? .yellow : .gray)
            }
            
            Spacer()
            
            // Increment Button
            Button(action: incrementAction) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(isCompleted ? .white : .blue)
                    .font(.title2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(
            Color(isCompleted ? UIColor.systemYellow : UIColor.systemGray6)
                .opacity(0.8)
                .animation(.easeInOut, value: isCompleted)
        )
        .cornerRadius(10)
        .shadow(radius: isCompleted ? 5 : 3)
    }
}

