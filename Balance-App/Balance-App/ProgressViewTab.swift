import SwiftUI

struct ProgressViewTab: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State private var progressData: [(date: String, physical: Double, mental: Double, custom: Double)] = []

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title
                    Text("Your Progress Over the Last 30 Days")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                        .padding(.top, 20)

                    // Calendar-like Progress Grid wrapped in a container
                    VStack {
                        LazyVGrid(
                            columns: Array(
                                repeating: GridItem(.flexible()),
                                count: verticalSizeClass == .regular ? 7 : 10
                            ),
                            spacing: 20
                        ) {
                            ForEach(progressData, id: \.date) { progress in
                                VStack(spacing: 8) {
                                    // Circular Progress View
                                    CircleProgressView(
                                        progress1: progress.physical,
                                        progress2: progress.mental,
                                        progress3: progress.custom,
                                        size: 40
                                    )

                                    // Date label
                                    Text(shortDate(from: progress.date))
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .background(Color(UIColor.systemGray6).opacity(0.8))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .shadow(radius: 5)
                }
                // Added padding to the outer VStack to prevent the background from touching the screen edges
                .padding(.horizontal)
            }
            .onAppear {
                fetchProgressData()
            }
        }
    }

    // MARK: - Fetch Progress Data
    private func fetchProgressData() {
        let last30Days = generateLast30Days()
        var tempData: [(date: String, physical: Double, mental: Double, custom: Double)] = []

        for day in last30Days {
            let physicalProgress = coreDataViewModel.getDailyProgress(for: day, type: .physical)
            let mentalProgress = coreDataViewModel.getDailyProgress(for: day, type: .mental)
            let customProgress = coreDataViewModel.getDailyProgress(for: day, type: .custom)

            tempData.append((date: day, physical: physicalProgress, mental: mentalProgress, custom: customProgress))
        }

        // Keep dates in ascending order (oldest to newest)
        progressData = tempData
    }

    // MARK: - Date Helpers
    private func generateLast30Days() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let today = Date()
        return (0..<30).map { offset in
            guard let date = Calendar.current.date(byAdding: .day, value: -offset, to: today) else { return "" }
            return formatter.string(from: date)
        }.reversed() // Reversed to display from oldest to newest
    }

    private func shortDate(from fullDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: fullDate) else { return fullDate }
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Circular Progress View
struct CircleProgressView: View {
    var progress1: Double
    var progress2: Double
    var progress3: Double
    var size: CGFloat

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                .frame(width: size, height: size)

            // Physical Progress (Green)
            Circle()
                .trim(from: 0, to: CGFloat(progress1))
                .stroke(Color.green, lineWidth: 4)
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)

            // Mental Progress (Purple)
            Circle()
                .trim(from: 0, to: CGFloat(progress2))
                .stroke(Color.purple, lineWidth: 4)
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)

            // Custom Progress (Blue)
            Circle()
                .trim(from: 0, to: CGFloat(progress3))
                .stroke(Color.blue, lineWidth: 4)
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
        }
    }
}

// MARK: - CoreDataViewModel Extension for Progress Fetching
extension CoreDataViewModel {
    func getDailyProgress(for date: String, type: ProgressType) -> Double {
        switch type {
        case .physical:
            if let progress = fitnessEntity?.dailyProgress as? [String: Double] {
                return progress[date] ?? 0.0
            }
        case .mental:
            if let progress = mentalHealthEntity?.dailyProgress as? [String: Double] {
                return progress[date] ?? 0.0
            }
        case .custom:
            if let progress = customGoalsEntity?.dailyProgress as? [String: Double] {
                return progress[date] ?? 0.0
            }
        }
        return 0.0
    }
}
