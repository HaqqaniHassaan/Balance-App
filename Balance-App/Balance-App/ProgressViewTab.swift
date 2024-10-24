import SwiftUI

struct ProgressViewTab: View {
    // Inject the CoreDataViewModel instance as an observed object
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass // Detect orientation

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0)
                    .ignoresSafeArea()

                // Use different layouts based on orientation
                VStack {
                    // Title
                    Text("Your Progress So Far...")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                        .shadow(color: .black, radius: 0.1, x: 0, y: 2)
                        .padding()

                    // Grid layout
                    if verticalSizeClass == .regular {
                        // Portrait Mode
                        progressGrid(columns: 7, circleSize: 40, fontSize: .caption)
                    } else {
                        // Landscape Mode
                        progressGrid(columns: 10, circleSize: 30, fontSize: .caption2)
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Grid for Progress Circles
    @ViewBuilder
    private func progressGrid(columns: Int, circleSize: CGFloat, fontSize: Font) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 10) {
            ForEach(1...30, id: \.self) { day in
                ZStack {
                    // Placeholder progress for physical, mental, and custom goals
                    let physicalProgress = progressPlaceholder(for: day, type: .physical)
                    let mentalProgress = progressPlaceholder(for: day, type: .mental)
                    let customProgress = progressPlaceholder(for: day, type: .custom)
                    
                    // Progress Ring
                    CircleProgressView(
                        progress1: physicalProgress,
                        progress2: mentalProgress,
                        progress3: customProgress,
                        size: circleSize
                    )

                    // Day number overlay
                    Text("\(day)")
                        .font(fontSize)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }

    // MARK: - Helper Function to Simulate Placeholder Progress
    private func progressPlaceholder(for day: Int, type: ProgressType) -> Double {
        // Example logic to simulate different progress for each type
        switch type {
        case .physical:
            return (day % 4 == 0) ? 1.0 : (day % 4 == 1) ? 0.75 : (day % 4 == 2) ? 0.5 : 0.25
        case .mental:
            return (day % 3 == 0) ? 1.0 : (day % 3 == 1) ? 0.6 : 0.3
        case .custom:
            return (day % 2 == 0) ? 0.8 : 0.4
        }
    }
}

// MARK: - Circular Progress View
struct CircleProgressView: View {
    var progress1: Double // Physical
    var progress2: Double // Mental
    var progress3: Double // Custom
    var size: CGFloat

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 5)
                .frame(width: size, height: size)
            
            // Physical Progress (Green)
            Circle()
                .trim(from: 0, to: CGFloat(progress1))
                .stroke(Color.green, lineWidth: 5)
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)

            // Mental Progress (Purple)
            Circle()
                .trim(from: 0, to: CGFloat(progress2))
                .stroke(Color.purple, lineWidth: 5)
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)

            // Custom Progress (Blue)
            Circle()
                .trim(from: 0, to: CGFloat(progress3))
                .stroke(Color.blue, lineWidth: 5)
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
        }
    }
}

// MARK: - Progress Type Enum
enum ProgressType {
    case physical
    case mental
    case custom
}

// Preview for ProgressViewTab
#Preview {
    ProgressViewTab(coreDataViewModel: CoreDataViewModel())
}
