import SwiftUI

@main
struct Balance_AppApp: App {
    // Create a shared instance of CoreDataViewModel
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @State private var showSplash = true // State to manage splash visibility

    var body: some Scene {
        WindowGroup {
            if showSplash {
                // Pass coreDataViewModel to SplashScreenView
                SplashScreenView(coreDataViewModel: coreDataViewModel)
                    .onAppear {
                        // Delay transition to the main flow
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            showSplash = false
                        }
                    }
            } else {
                // Check if onboarding is completed
                if coreDataViewModel.isOnboardingCompleted() {
                    ContentView(coreDataViewModel: coreDataViewModel)
                } else {
                    OnboardingWelcomeView(coreDataViewModel: coreDataViewModel)
                }
            }
        }
    }
}
