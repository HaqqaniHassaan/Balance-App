import SwiftUI

struct CustomGoalsTitleView: View {
    var body: some View {
        Text("Today's Custom Goals")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
            .padding(.top, 20)
    }
}

 
