import SwiftUI

struct HomeView: View {
    // Inject the CoreDataViewModel instance as an observed object
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    /*
    init() {
        // Update UINavigationBar appearance for large titles
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.white]
    }
     */
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Physical Health Widget
                    NavigationLink(destination: FitnessDetailView(coreDataViewModel: coreDataViewModel)) {
                        WidgetView(title: "Today's Physical Health", backgroundColor: .green, icon: "figure.walk.circle.fill")
                    }
                    
                    // Mental Wellbeing Widget
                    NavigationLink(destination: MentalHealthDetailView(coreDataViewModel: coreDataViewModel)) {
                        WidgetView(title: "Today's Mental Health", backgroundColor: .purple, icon: "brain.head.profile")
                    }
                    
                    // Custom Goals Widget
                    NavigationLink(destination: CustomGoalsDetailView(coreDataViewModel: coreDataViewModel)) {
                        WidgetView(title: "Today's Custom Goals", backgroundColor: .cyan, icon: "star.circle.fill")
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Balance")
                .onAppear {
                    // Set navigation bar appearance when the view appears
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                }
            }
        }
    }
}

// Reusable widget component
struct WidgetView: View {
    var title: String
    var backgroundColor: Color
    var icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

