//
//  ContentView.swift
//  Balance-App
//
//  Created by user264048 on 10/21/24.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ProgressViewTab()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Progress")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.purple) 
    }
}




#Preview {
    ContentView()
}
