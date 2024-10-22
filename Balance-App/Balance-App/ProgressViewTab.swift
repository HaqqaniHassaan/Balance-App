import SwiftUI

struct ProgressViewTab: View {
    // Inject the CoreDataViewModel instance as an observed object
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0)
                    .ignoresSafeArea()

                VStack {
                    // Title
                    Text("Your Progress So Far...")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .shadow(color: .black, radius: 0.1, x: 0, y: 2)
                        .padding()

                    // Calendar Placeholder
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(1...30, id: \.self) { day in
                            ZStack {
                                Circle()
                                    .fill(isProgressDay(day) ? Color.green : Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 40)

                                Text("\(day)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()

                    Spacer()
                }
                .padding()
            }
        }
    }

    // Helper function to determine progress day
    private func isProgressDay(_ day: Int) -> Bool {
        // Example logic to simulate user progress (can be replaced with real data later)
        let currentDay = Calendar.current.component(.day, from: Date())
        return day <= currentDay && day % 2 == 0 // Simulated progress: marks even days up to current day
    }
}

// Preview for ProgressViewTab
struct ProgressViewTab_Previews: PreviewProvider {
    static var previews: some View {
        ProgressViewTab(coreDataViewModel: CoreDataViewModel())
    }
}
