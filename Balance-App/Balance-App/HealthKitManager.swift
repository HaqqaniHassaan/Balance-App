import HealthKit

class HealthKitManager {
    // Singleton instance for centralized access
    static let shared = HealthKitManager()
    
    // HealthStore instance to manage HealthKit data interactions
    private let healthStore = HKHealthStore()

    // Private initializer to ensure singleton usage
    private init() {}

    // MARK: - Authorization
    /// Requests authorization to read HealthKit data.
    /// - Parameter completion: Completion handler that returns success as Bool and an optional error.
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKitManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device."]))
            return
        }

        // Define the data types to read from HealthKit
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]

        // Request authorization to read the defined data types
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    // MARK: - Fetch Step Count
    /// Fetches the step count for the current day.
    /// - Parameter completion: Completion handler that returns the step count as Double and an optional error.
    func fetchStepCount(completion: @escaping (Double?, Error?) -> Void) {
        // Define the step count data type
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step Count type is unavailable."]))
            return
        }

        // Define the time interval for fetching steps (start of the current day)
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        // Create the statistics query to retrieve cumulative step count
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // Extract the step count value
            let stepCount = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            DispatchQueue.main.async {
                completion(stepCount, nil)
            }
        }

        // Execute the query
        healthStore.execute(query)
    }

    // MARK: - Fetch Active Energy Burned
    /// Fetches the active energy burned for the current day.
    /// - Parameter completion: Completion handler that returns the energy burned as Double and an optional error.
    func fetchActiveEnergyBurned(completion: @escaping (Double?, Error?) -> Void) {
        // Define the active energy burned data type
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Active Energy type is unavailable."]))
            return
        }

        // Define the time interval for fetching active energy burned (start of the current day)
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        // Create the statistics query to retrieve cumulative active energy burned
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // Extract the active energy burned value
            let energyBurned = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
            DispatchQueue.main.async {
                completion(energyBurned, nil)
            }
        }

        // Execute the query
        healthStore.execute(query)
    }

    // MARK: - Fetch Exercise Time
    /// Fetches the exercise time for the current day.
    /// - Parameter completion: Completion handler that returns the exercise time as Double and an optional error.
    func fetchExerciseTime(completion: @escaping (Double?, Error?) -> Void) {
        // Define the exercise time data type
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Exercise Time type is unavailable."]))
            return
        }

        // Define the time interval for fetching exercise time (start of the current day)
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        // Create the statistics query to retrieve cumulative exercise time
        let query = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // Extract the exercise time value
            let exerciseTime = result?.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0.0
            DispatchQueue.main.async {
                completion(exerciseTime, nil)
            }
        }

        // Execute the query
        healthStore.execute(query)
    }
}
