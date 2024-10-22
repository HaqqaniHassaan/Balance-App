import HealthKit

class HealthKitManager {
    // Singleton instance
    static let shared = HealthKitManager()
    
    // HealthStore instance
    private let healthStore = HKHealthStore()

    // Private initializer to ensure singleton usage
    private init() {}

    // MARK: - Authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        // Define the data types to read
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]

        // Request authorization
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    // MARK: - Fetch Step Count
    func fetchStepCount(completion: @escaping (Double?, Error?) -> Void) {
        // Define the step count type
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step Count type is unavailable."]))
            return
        }

        // Define the time interval for fetching steps (start of the current day)
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        // Create the statistics query
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // Extract the step count
            let stepCount = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            DispatchQueue.main.async {
                completion(stepCount, nil)
            }
        }

        // Execute the query
        healthStore.execute(query)
    }

    // MARK: - Fetch Active Energy Burned
    func fetchActiveEnergyBurned(completion: @escaping (Double?, Error?) -> Void) {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Active Energy type is unavailable."]))
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            let energyBurned = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
            DispatchQueue.main.async {
                completion(energyBurned, nil)
            }
        }

        healthStore.execute(query)
    }

    // MARK: - Fetch Exercise Time
    func fetchExerciseTime(completion: @escaping (Double?, Error?) -> Void) {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "Exercise Time type is unavailable."]))
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            let exerciseTime = result?.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0.0
            DispatchQueue.main.async {
                completion(exerciseTime, nil)
            }
        }

        healthStore.execute(query)
    }
}
