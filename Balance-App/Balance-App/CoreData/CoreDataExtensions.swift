import Foundation
import CoreData

extension CustomGoalsEntity {
    /// Computed property to work with the `goals` relationship as a `Set<Goal>`.
    var goalsSet: Set<Goal> {
        get {
            (goals as? Set<Goal>) ?? []
        }
        set {
            goals = NSSet(set: newValue)
        }
    }
}
