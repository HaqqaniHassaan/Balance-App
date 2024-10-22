//
//  Balance_AppApp.swift
//  Balance-App
//
//  Created by user264048 on 10/21/24.
//

import SwiftUI

@main
struct Balance_AppApp: App {
    // Initialize the CoreDataViewModel
    @StateObject private var coreDataViewModel = CoreDataViewModel()

    var body: some Scene {
        WindowGroup {
            OnboardingWelcomeView(coreDataViewModel: coreDataViewModel)
        }
    }
}
