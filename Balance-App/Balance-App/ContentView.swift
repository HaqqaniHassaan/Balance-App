import SwiftUI

struct ContentView: View {
    // Accept the shared instance of CoreDataViewModel
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    init(coreDataViewModel: CoreDataViewModel) {
        self.coreDataViewModel = coreDataViewModel
        
        // Configure the tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(white: 0.4, alpha: 0.4) // Semi-transparent gray color
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
            // Update UINavigationBar appearance for large titles
        
    }

    var body: some View {
        ZStack {
            // Your background image or color here

            TabView {
                HomeView(coreDataViewModel: coreDataViewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                ProgressViewTab(coreDataViewModel: coreDataViewModel)
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                    }
                
                SettingsView(coreDataViewModel: coreDataViewModel)
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
            }
            .accentColor(.white)
        }
    }
}

#Preview {
    ContentView(coreDataViewModel: CoreDataViewModel())
}
