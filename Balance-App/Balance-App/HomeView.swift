import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Physical Health Widget
                NavigationLink(destination: FitnessDetailView()) {
                    WidgetView(title: "Today's Physical Health", backgroundColor: .green, icon: "figure.walk.circle.fill")
                }

                // Mental Wellbeing Widget
                NavigationLink(destination: MentalHealthDetailView()) {
                    WidgetView(title: "Today's Mental Health", backgroundColor: .purple, icon: "brain.head.profile")
                }

                // Custom Goals Widget
                NavigationLink(destination: CustomGoalsDetailView()) {
                    WidgetView(title: "Today's Custom Goals", backgroundColor: .cyan, icon: "star.circle.fill")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Balance")
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
