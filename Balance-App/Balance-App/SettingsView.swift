import SwiftUI

struct SettingsView: View {
    var body: some View {
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
