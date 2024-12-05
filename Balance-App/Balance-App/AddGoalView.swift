import SwiftUI



// MARK: - Add Goal View
struct AddGoalView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.dismiss) var dismiss

    @State private var goalName = ""
    @State private var targetValue: String = ""
    @State private var isCheckable = false

    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Name", text: $goalName)
                        .autocapitalization(.words)
                    TextField("Target Value", text: $targetValue)
                        .keyboardType(.numberPad)
                    Toggle("Checkable Goal", isOn: $isCheckable)
                }
            }
            .navigationBarTitle("Add New Goal", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                saveGoal()
            })
        }
    }

    private func saveGoal() {
        guard let target = Int64(targetValue), !goalName.isEmpty else {
            // Optionally, show an alert if validation fails
            return
        }
        coreDataViewModel.addCustomGoal(name: goalName, target: target, isCheckable: isCheckable)
        onSave()
        dismiss()
    }
}
