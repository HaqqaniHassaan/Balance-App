import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var fitnessEntity: FitnessEntity?
    @Published var mentalHealthEntity: MentalHealthEntity?
    @Published var customGoalsEntity: CustomGoalsEntity?

    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading Core Data: \(error)")
            } else {
                print("Core Data loaded successfully.")
                self.fetchData() // Fetch data after loading persistent stores
            }
        }
    }

    func fetchData() {
        // Fetch FitnessEntity
        let request: NSFetchRequest<FitnessEntity> = FitnessEntity.fetchRequest()
        if let fetchedFitness = try? container.viewContext.fetch(request).first {
            self.fitnessEntity = fetchedFitness
        } else {
            // If no entity exists, create one
            let newFitnessEntity = FitnessEntity(context: container.viewContext)
            self.fitnessEntity = newFitnessEntity
        }

        // Similarly, fetch MentalHealthEntity and CustomGoalsEntity
        let mentalRequest: NSFetchRequest<MentalHealthEntity> = MentalHealthEntity.fetchRequest()
        if let fetchedMental = try? container.viewContext.fetch(mentalRequest).first {
            self.mentalHealthEntity = fetchedMental
        } else {
            let newMentalEntity = MentalHealthEntity(context: container.viewContext)
            self.mentalHealthEntity = newMentalEntity
        }

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

    // Example method to update FitnessEntity
    func updateFitnessGoal(for attribute: WritableKeyPath<FitnessEntity, Bool>, value: Bool) {
        fitnessEntity?[keyPath: attribute] = value
        saveData()
    }
    
    // Example method to update MentalHealthEntity
    func updateMentalHealthGoal(for attribute: WritableKeyPath<MentalHealthEntity, Bool>, value: Bool) {
        mentalHealthEntity?[keyPath: attribute] = value
        saveData()
    }
    
    func updateCustomGoal<T>(for keyPath: ReferenceWritableKeyPath<CustomGoalsEntity, T>, value: T) {
        guard let customGoalsEntity = customGoalsEntity else { return }
        customGoalsEntity[keyPath: keyPath] = value
        saveData()
    }

}
