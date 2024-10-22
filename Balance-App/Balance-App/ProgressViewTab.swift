import SwiftUI

struct ProgressViewTab: View {
    var body: some View {
        NavigationView {
            
            ZStack {
                Image("background_image")
                     .resizable()
                     .scaledToFill()
                     .frame(minWidth: 0) // 👈 This will keep other views (like a large text) in the frame
                     .ignoresSafeArea()
                VStack {
                    Text("Your Progress So Far...")
                        .font(.title)
                        .foregroundColor(.white) // Adjusted text color for better visibility
                        .padding()
                    
                    // Simple Calendar Placeholder
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(1...30, id: \.self) { day in
                            ZStack {
                                Circle()
                                    .stroke(Color.green, lineWidth: 2)
                                    .frame(width: 40, height: 40)
                                
                                Text("\(day)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
        // Adding tabItem directly in ProgressViewTab
        .tabItem {
            Image(systemName: "chart.bar.fill")
            Text("Progress")
        }
    }
}

struct ProgressViewTab_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewTab()
    }
}
