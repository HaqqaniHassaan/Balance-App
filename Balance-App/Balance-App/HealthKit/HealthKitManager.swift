import HealthKit

class HealthKitManager {
    // Singleton instance for centralized access
    static let shared = HealthKitManager()
    
    // HealthStore instance to manage HealthKit data interactions
    private let healthStore = HKHealthStore()

    // Private initializer to ensure singleton usage
    private init() {}

    // MARK: - Authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKitManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device."]))
            return
        }

        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)! // Added sleep analysis
        ]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    // MARK: - Fetch Step Count
    func fetchStepCount(completion: @escaping (Double?, Error?) -> Void) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step Count type is unavailable."]))
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                completion(nil, error)
                return
            }

            let stepCount = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            DispatchQueue.main.async {
                completion(stepCount, nil)
            }
        }

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

    // MARK: - Fetch Sleep Analysis
    func fetchSleepData(completion: @escaping (Double?, Error?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthKitManager", code: 4, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type is unavailable."]))
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                completion(nil, error)
                return
            }

            // Calculate total sleep time in minutes
            var totalSleepMinutes = 0.0

            if let results = results as? [HKCategorySample] {
                for sample in results {
                    // Check for 'asleepUnspecified' instead of the deprecated 'asleep'
                    if sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue ||
                       sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                       sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                       sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue {
                        
                        let sleepDuration = sample.endDate.timeIntervalSince(sample.startDate)
                        totalSleepMinutes += sleepDuration / 60
                    }
                }
            }

            DispatchQueue.main.async {
                completion(totalSleepMinutes, nil)
            }

        }

        healthStore.execute(query)
    }
}
