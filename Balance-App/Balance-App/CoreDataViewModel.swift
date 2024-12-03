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
    // Update integer metrics in MentalHealthEntity
    func updateMentalHealthMetric(for keyPath: WritableKeyPath<MentalHealthEntity, Int64>, value: Int64) {
        mentalHealthEntity?[keyPath: keyPath] = value
        saveData()
    }
    // Update Family Call Minutes
    func updateFamilyCallMinutes(_ value: Int) {
        mentalHealthEntity?.familyCallMinutes = Int64(value)
        saveData()
    }

    // Update Mindful Breathing Minutes
    func updateMindfulBreathingMinutes(_ value: Int) {
        mentalHealthEntity?.mindfulBreathingMinutes = Int64(value)
        saveData()
    }

    // Update Screen-Off Minutes
    func updateScreenOffMinutes(_ value: Int) {
        mentalHealthEntity?.screenOffMinutes = Int64(value)
        saveData()
    }
    // Update Tracking Booleans for MentalHealth Goals
    func updateMentalHealthTracking(for attribute: WritableKeyPath<MentalHealthEntity, Bool>, value: Bool) {
        mentalHealthEntity?[keyPath: attribute] = value
        saveData()
    }


    // Add this to CoreDataViewModel
    func addCustomGoal(name: String, target: Int64, isCheckable: Bool = false) {
        guard let customGoalsEntity = self.customGoalsEntity else { return }

        let newGoal = Goal(context: container.viewContext)
        newGoal.name = name
        newGoal.target = target
        newGoal.progress = 0
        newGoal.isCheckable = isCheckable
        newGoal.customGoalsEntity = customGoalsEntity

        saveData()
    }


    func deleteGoal(_ goal: Goal) {
        container.viewContext.delete(goal)
        saveData()
    }
    func updateGoalProgress(_ goal: Goal, progress: Int64) {
        goal.progress = progress
        saveData()
    }
    func fetchStreaks(forEntity entity: GoalEntityType, streakKey: String) -> (current: Int, longest: Int)? {
        switch entity {
        case .fitness:
            guard let fitnessEntity = fitnessEntity else { return nil }
            return fetchEntityStreaks(entity: fitnessEntity, streakKey: streakKey)
        case .mentalHealth:
            guard let mentalHealthEntity = mentalHealthEntity else { return nil }
            return fetchEntityStreaks(entity: mentalHealthEntity, streakKey: streakKey)
        case .customGoals:
            guard let customGoalsEntity = customGoalsEntity else { return nil }
            return fetchEntityStreaks(entity: customGoalsEntity, streakKey: streakKey)
        }
    }


    private func fetchEntityStreaks<T: NSManagedObject>(entity: T, streakKey: String) -> (current: Int, longest: Int)? {
        guard let streaksDict = entity.value(forKey: "streaks") as? [String: [String: Int]] else { return nil }
        let current = streaksDict[streakKey]?["current"] ?? 0
        let longest = streaksDict[streakKey]?["longest"] ?? 0
        return (current: current, longest: longest)
    }


    // Update Streak
    func updateStreak(for entity: String, goalKey: String, streakValue: Int) {
        switch entity {
        case "Fitness":
            if fitnessEntity?.streaks == nil {
                fitnessEntity?.streaks = [:] as NSDictionary
            }
            var currentStreaks = fitnessEntity?.streaks as? [String: Int] ?? [:]
            currentStreaks[goalKey] = streakValue
            fitnessEntity?.streaks = currentStreaks as NSDictionary
        case "MentalHealth":
            if mentalHealthEntity?.streaks == nil {
                mentalHealthEntity?.streaks = [:] as NSDictionary
            }
            var currentStreaks = mentalHealthEntity?.streaks as? [String: Int] ?? [:]
            currentStreaks[goalKey] = streakValue
            mentalHealthEntity?.streaks = currentStreaks as NSDictionary
        case "CustomGoals":
            if customGoalsEntity?.streaks == nil {
                customGoalsEntity?.streaks = [:] as NSDictionary
            }
            var currentStreaks = customGoalsEntity?.streaks as? [String: Int] ?? [:]
            currentStreaks[goalKey] = streakValue
            customGoalsEntity?.streaks = currentStreaks as NSDictionary
        default:
            break
        }
        saveData()
    }
    enum GoalEntityType {
        case fitness
        case mentalHealth
        case customGoals
    }

    // Reset Streak
    func resetStreak(for entity: String, goalKey: String) {
        updateStreak(for: entity, goalKey: goalKey, streakValue: 0)
    }

    // Increment Streak
    func incrementStreak(for entity: GoalEntityType, streakKey: String) {
        // Fetch existing streaks or initialize them
        guard let streaks = fetchStreaks(forEntity: entity, streakKey: streakKey) else {
            if let entityObject = getEntity(for: entity) {
                updateEntityStreaks(
                    entity: entityObject,
                    streakKey: streakKey,
                    didComplete: true
                )
            }
            return
        }
        
        // Update streaks
        let newCurrentStreak = streaks.current + 1
        let newLongestStreak = max(streaks.longest, newCurrentStreak)

        // Safely unwrap entity
        if let entityObject = getEntity(for: entity) {
            updateEntityStreaks(
                entity: entityObject,
                streakKey: streakKey,
                didComplete: true
            )
        } else {
            print("Error: Entity object for \(entity) is nil.")
        }
    }

    private func getEntity(for entityType: GoalEntityType) -> NSManagedObject? {
        switch entityType {
        case .fitness:
            return fitnessEntity
        case .mentalHealth:
            return mentalHealthEntity
        case .customGoals:
            return customGoalsEntity
        }
    }



    func fetchCustomGoals() -> [Goal] {
        guard let customGoalsEntity = self.customGoalsEntity else { return [] }
        return Array(customGoalsEntity.goals as? Set<Goal> ?? [])
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
    
     func updateEntityStreaks<T: NSManagedObject>(entity: T, streakKey: String, didComplete: Bool) {
        guard var streaksDict = entity.value(forKey: "streaks") as? [String: [String: Int]] else {
            let newStreak = ["current": didComplete ? 1 : 0, "longest": didComplete ? 1 : 0]
            entity.setValue([streakKey: newStreak], forKey: "streaks")
            saveData()
            return
        }

        var currentStreak = streaksDict[streakKey]?["current"] ?? 0
        var longestStreak = streaksDict[streakKey]?["longest"] ?? 0

        if didComplete {
            currentStreak += 1
            longestStreak = max(longestStreak, currentStreak)
        } else {
            currentStreak = 0
        }

        streaksDict[streakKey] = ["current": currentStreak, "longest": longestStreak]
        entity.setValue(streaksDict, forKey: "streaks")
        saveData()
    }


}
