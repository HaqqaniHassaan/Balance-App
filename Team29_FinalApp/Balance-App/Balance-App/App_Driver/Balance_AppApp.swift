import SwiftUI
@main
/* Developed by Hassaan Haqqani, still in active development*/
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


/**
 Final app patch notes: Added timed exercises for meditation, stretches, updated colors per discussion with professor in prior class (to be more in line with Apple's health scheme), added backgrounds for
 better contrast, many UI tweaks, functional revamps, (progressview implementation, streaks implementation). Organized/added project structure into folders for different categories (components, coredata etc)
 
 
 The most important and longest implementation was learning and implementing persistent storage to track goal data long term (CoreData)
 Fitness Goals and DetailView (and the whole flow from onboarding to fitnessdetailview) is functionally complete. I prioritized this becausee unless the other two goals (Mental health and custom) fitness
 goals require both HealthKit and CoreData implementation. I implemented our CoreData using the MVVC model (which utilizes the CoreDataViewModel to serve as an intermediary between our CoreData and SwiftUI views
 and then also utilized HealthKit data tracking and syncing to assist with fitness goals.
 
 The app has full functionality in terms of userflow
 You will first (and only once) do onboarding,  the onboarding once complete is saved to local storage and the user will never have to do it again (unless choosing to reset data in settings)
 Otherwise based on the onboarding picks, the fitness detail view is populated and persistently tracked as planned.
 
 Overall, Fitness goals and flow is very robust and complete, I would say, having all the core functionality and
 full persistent data storage in every aspect (and now is only needed to be expanded upon with new goals, streaks etc)
 
 For mental health and custom goals you will notice a lack of persistent data storage like in fitnessdetailview and this is because the functionality is already complete, it will be an exact duplicate of the goalsoverview (the manually incremented goals section of fitness detail view) since these other two flows don't require healthkit, on a functional level it will be a matter of just implementing it the exact same way (adding helper functions in coredataviewmodel, attributes in our coredatamodel) (just with different names for goals and different UI touch ups) (However also did implement fully preference tracking for mental health from onboarding that is persistently saved in this version)
(it is just progress that isn't implemented because it is a 1:1 implementation of fitnessdetailview so I opted to switch my focus to UI/flow at this point)
 

 After getting the functionality set up, I chose to implement our UI, which I find to be a sleek and stylish UI based on our wireframes.

 */
