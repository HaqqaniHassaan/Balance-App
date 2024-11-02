<p>
  <img src="https://i.imgur.com/Ahyhyr4.png" width="120" height="120" alt="App Icon"/>
</p>

# Balance: Your All-In-One Lifestyle App






**Balance** is a all-in-one lifestyle app that empowers users to set, track, and maintain both physical and mental health goals. Designed to encourage a balanced lifestyle, the app integrates seamlessly with HealthKit for physical metrics as well as CoreData for persistent data tracking and offers personalized goal-setting capabilities.
Balance is still in active development, stay tuned and follow this repo for updates!
<p align="center">
  <img src="https://i.imgur.com/NAW8RXx.png" width="200" alt="Onboarding"/>
  <img src="https://i.imgur.com/oQv1o96.png" width="200" alt="Home View"/>
  <img src="https://i.imgur.com/lZAhm6v.png" width="200" alt="Goals View"/>
</p>

## Overview

The Balance app is structured using **MVVC (Model-View-ViewModel-Coordinator)** architecture to maintain a clean, modular, and easily scalable codebase. This design choice enhances code reusability and separation of concerns, enabling clear boundaries between the user interface, data handling, and business logic.

## Key Features

- **Goal Tracking**: Track both physical and mental wellness goals, such as workouts, meditation, and outdoor time.
- **Customizable Goals**: Go beyond pre-set options by creating custom goals, providing a personalized experience.
- **HealthKit Integration**: Syncs with HealthKit to automatically track physical health metrics like steps, calories, and workout duration.
- **Data Persistence with Core Data**: Stores user-selected goals and progress locally, allowing data to persist across app launches.
- **Engaging User Interface**: Custom-designed UI for an engaging and immersive experience, including personalized onboarding, goal progress views, and an interactive calendar for daily achievements.

## Implementation Details

### Architecture and Design

Balance is built with **MVVC architecture** to support a clean, modular code structure:

- **Model**: Core Data models and HealthKit integrations handle data storage and physical health metrics.
- **ViewModel**: The `CoreDataViewModel` class manages data retrieval, update operations, and HealthKit authorization and data fetching. It acts as the intermediary between the Model and Views, ensuring data binding and logic handling.
- **View**: SwiftUI views present the data to the user with dynamic elements that adjust based on user interaction and HealthKit data.
- **Coordinator (if applicable)**: Handles navigation and flow, managing transitions between different screens, especially during onboarding.

### Development Process

Balance’s design was meticulously planned using **wireframes and mockups** created in Figma, which are available in the "App Specification" folder in this GitHub repository. These designs serve as the blueprint for the app's structure, ensuring a consistent and user-centered approach to development.

- **Onboarding Flow**: Guides users through a personalized setup, allowing them to select physical, mental, and custom goals. Each onboarding screen is designed with transparency effects and individual goal tracking toggles.
- **Home and Progress Views**: The Home View serves as a dashboard for daily goals, while the Progress View provides a visual calendar representation of progress, using color-coded indicators for different goal categories.
- **Goal Tracking**: Utilizes HealthKit data to automatically update physical health metrics, with Core Data handling the local storage of progress.

## Technologies

- **SwiftUI**: Used for building the UI, with support for both portrait and landscape orientations.
- **Core Data**: Ensures data persistence for goal-tracking selections and user progress.
- **HealthKit**: Syncs and fetches data directly from the HealthKit API for physical activity metrics.
- **Figma**: Employed during the design phase to create mockups and wireframes, ensuring that development aligns closely with the intended user experience.

## Installation

1. Clone the repository.
2. Open `Balance.xcodeproj` in Xcode.
3. Run on iOS Simulator or a physical device with iOS 15+.

