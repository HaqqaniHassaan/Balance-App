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
                                .foregroundColor(.blue)
                        }
                        Button(action: {}) {
                            Text("Goal Preferences")
                                .foregroundColor(.blue)

                        }
                    }
                    
                    Section(header: Text("About")) {
                        Button(action: {}) {
                            Text("Privacy Policy")
                                .foregroundColor(.blue)

                        }
                        Button(action: {}) {
                            Text("Reset All Data")
                                .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("Settings")
            }
            .onAppear {
                // Set navigation bar appearance when the view appears
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            }
        }
    }
}

#Preview {
    SettingsView(coreDataViewModel: CoreDataViewModel())
}
