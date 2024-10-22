//
//  Balance_AppApp.swift
//  Balance-App
//
//  Created by user264048 on 10/21/24.
//

import SwiftUI

@main
struct Balance_AppApp: App {
    // Create a shared instance of CoreDataViewModel
    @StateObject private var coreDataViewModel = CoreDataViewModel()

    var body: some Scene {
        WindowGroup {
            if coreDataViewModel.isOnboardingCompleted() {
                ContentView(coreDataViewModel: coreDataViewModel) // Pass to ContentView
            } else {
                OnboardingWelcomeView(coreDataViewModel: coreDataViewModel) // Pass to Onboarding
            }
        }
    }
}
