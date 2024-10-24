import CoreData
import SwiftUI
import HealthKit

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var fitnessEntity: FitnessEntity?
    @Published var mentalHealthEntity: MentalHealthEntity?
    @Published var customGoalsEntity: CustomGoalsEntity?
    private let healthKitManager = HealthKitManager.shared // Use the HealthKitManager
    private var healthStore: HKHealthStore?

    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data: \(error)")
            } else {
                print("Core Data loaded successfully.")
                self.fetchData()
                self.requestHealthKitAuthorization() // Request HealthKit authorization
            }
        }
    }

    // MARK: - HealthKit Authorization & Setup
    private func requestHealthKitAuthorization() {
        healthKitManager.requestAuthorization { [weak self] success, error in
            if let error = error {
                print("HealthKit Authorization Error: \(error.localizedDescription)")
                return
            }
            
            if success {
                print("HealthKit authorization successful.")
                self?.fetchHealthData() // Fetch initial health data
            } else {
                print("HealthKit authorization denied.")
            }
        }
    }

    // MARK: - Fetch HealthKit Data
    private func fetchHealthData() {
        fetchStepCount()
        fetchCaloriesBurned()
        fetchExerciseTime()
    }

    private func fetchStepCount() {
        healthKitManager.fetchStepCount { [weak self] stepCount, error in
            guard let self = self, let steps = stepCount else {
                print("Failed to fetch steps: \(String(describing: error))")
                return
            }

            // Update Core Data with the step count
            DispatchQueue.main.async {
                self.fitnessEntity?.stepsWalked = Int64(steps)
                self.saveData()
            }
        }
    }

    private func fetchCaloriesBurned() {
        healthKitManager.fetchActiveEnergyBurned { [weak self] calories, error in
            guard let self = self, let caloriesBurned = calories else {
                print("Failed to fetch calories burned: \(String(describing: error))")
                return
            }

            // Update Core Data with calories burned
            DispatchQueue.main.async {
                self.fitnessEntity?.caloriesBurned = Int64(caloriesBurned)
                self.saveData()
            }
        }
    }

    private func fetchExerciseTime() {
        healthKitManager.fetchExerciseTime { [weak self] exerciseTime, error in
            guard let self = self, let exerciseMinutes = exerciseTime else {
                print("Failed to fetch exercise time: \(String(describing: error))")
                return
            }

            // Update Core Data with exercise time
            DispatchQueue.main.async {
                self.fitnessEntity?.workoutDuration = Float(exerciseMinutes)
                self.saveData()
            }
        }
    }

    // MARK: - Core Data Fetch & Save Methods
    func fetchData() {
        // Fetch FitnessEntity
        let fitnessRequest: NSFetchRequest<FitnessEntity> = FitnessEntity.fetchRequest()
        if let fetchedFitness = try? container.viewContext.fetch(fitnessRequest).first {
            self.fitnessEntity = fetchedFitness
        } else {
            // Create a new entity if it doesn't exist
            let newFitnessEntity = FitnessEntity(context: container.viewContext)
            self.fitnessEntity = newFitnessEntity
        }

        // Fetch MentalHealthEntity
        let mentalRequest: NSFetchRequest<MentalHealthEntity> = MentalHealthEntity.fetchRequest()
        if let fetchedMental = try? container.viewContext.fetch(mentalRequest).first {
            self.mentalHealthEntity = fetchedMental
        } else {
            let newMentalEntity = MentalHealthEntity(context: container.viewContext)
            self.mentalHealthEntity = newMentalEntity
        }

        // Fetch CustomGoalsEntity
        let customRequest: NSFetchRequest<CustomGoalsEntity> = CustomGoalsEntity.fetchRequest()
        if let fetchedCustom = try? container.viewContext.fetch(customRequest).first {
            self.customGoalsEntity = fetchedCustom
        } else {
            let newCustomEntity = CustomGoalsEntity(context: container.viewContext)
            self.customGoalsEntity = newCustomEntity
        }

        saveData() // Save initial data if needed
    }

    func saveData() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }

    // MARK: - Update Water Intake
    func updateWaterIntake(_ value: Int) {
        fitnessEntity?.waterIntake = Int64(value)
        saveData()
    }

    // MARK: - Update Stretching Minutes
    func updateStretchingMinutes(_ value: Int) {
        fitnessEntity?.stretchingMinutes = Int64(value)
        saveData()
    }

    // MARK: - Update Methods
    func updateFitnessGoal(for attribute: WritableKeyPath<FitnessEntity, Bool>, value: Bool) {
        fitnessEntity?[keyPath: attribute] = value
        saveData()
    }

    func updateFitnessMetric(for attribute: WritableKeyPath<FitnessEntity, Int64>, value: Int64) {
        fitnessEntity?[keyPath: attribute] = value
        saveData()
    }

    // Update MentalHealthEntity
    func updateMentalHealthGoal(for attribute: WritableKeyPath<MentalHealthEntity, Bool>, value: Bool) {
        mentalHealthEntity?[keyPath: attribute] = value
        saveData()
    }

    // Update CustomGoalsEntity
    func updateCustomGoal<T>(for keyPath: ReferenceWritableKeyPath<CustomGoalsEntity, T>, value: T) {
        customGoalsEntity?[keyPath: keyPath] = value
        saveData()
    }

    // MARK: - Onboarding Completion Logic
    func completeOnboarding() {
        if let customGoalsEntity = customGoalsEntity {
            customGoalsEntity.isOnboardingComplete = true
            saveData()
        }
    }

    func isOnboardingCompleted() -> Bool {
        return customGoalsEntity?.isOnboardingComplete ?? false
    }
}
