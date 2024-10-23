import SwiftUI

struct SettingsView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    var body: some View {
        ZStack {
            
            NavigationView {
                Form {
                    Section(header: Text("Profile")) {
                        NavigationLink("Edit Profile", destination: Text("Edit Profile View")) // Placeholder
                    }
                    
                    Section(header: Text("Notifications")) {
                        Toggle(isOn: .constant(true)) {
                            Text("Allow Notifications")
                        }
                    }
                    
                    Section(header: Text("General")) {
                        Button(action: {}) {
                            Text("Clear History")
                        }
                        Button(action: {}) {
                            Text("Goal Preferences")
                        }
                    }
                    
                    Section(header: Text("About")) {
                        Button(action: {}) {
                            Text("Privacy Policy")
                        }
                        Button(action: {}) {
                            Text("Reset All Data")
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}

#Preview {
    SettingsView(coreDataViewModel: CoreDataViewModel())
}
