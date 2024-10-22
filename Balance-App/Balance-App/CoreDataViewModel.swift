import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var fitnessEntities: [FitnessEntity] = []
    @Published var mentalHealthEntities: [MentalHealthEntity] = []
    @Published var customGoalsEntities: [CustomGoalsEntity] = []

    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data: \(error)")
            }
        }
        fetchAllData()
    }
    
    // Fetch all data
    func fetchAllData() {
        fetchFitnessData()
        fetchMentalHealthData()
        fetchCustomGoalsData()
    }

    // Fetch Fitness data
    func fetchFitnessData() {
        let request = NSFetchRequest<FitnessEntity>(entityName: "FitnessEntity")
        do {
            fitnessEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching FitnessEntity: \(error)")
        }
    }

    // Fetch Mental Health data
    func fetchMentalHealthData() {
        let request = NSFetchRequest<MentalHealthEntity>(entityName: "MentalHealthEntity")
        do {
            mentalHealthEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching MentalHealthEntity: \(error)")
        }
    }

    // Fetch Custom Goals data
    func fetchCustomGoalsData() {
        let request = NSFetchRequest<CustomGoalsEntity>(entityName: "CustomGoalsEntity")
        do {
            customGoalsEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching CustomGoalsEntity: \(error)")
        }
    }
    
    // Add new Fitness data
    func addFitnessData(isWorkoutTracked: Bool, caloriesBurned: Int64) {
        let newFitnessData = FitnessEntity(context: container.viewContext)
        newFitnessData.isWorkoutTracked = isWorkoutTracked
        newFitnessData.caloriesBurned = caloriesBurned
        saveData()
    }

    // Save data
    func saveData() {
        do {
            try container.viewContext.save()
            fetchAllData()
        } catch let error {
            print("Error saving data: \(error)")
        }
    }
}
