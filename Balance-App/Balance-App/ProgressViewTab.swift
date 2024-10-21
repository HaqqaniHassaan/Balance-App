import SwiftUI

struct ProgressViewTab: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Progress So Far...")
                    .font(.title)
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
            .navigationTitle("Progress")
        }
    }
}
