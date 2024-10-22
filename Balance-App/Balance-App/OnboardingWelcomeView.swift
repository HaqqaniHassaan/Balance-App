import SwiftUI

struct OnboardingWelcomeView: View {
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @State private var navigateToNext: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                // Welcome Title
                Text("Welcome to Balance")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .shadow(radius: 5)

                // Introductory Blurb
                Text("Your all-in-one lifestyle app to improve your physical, mental, and overall health. Are you ready to kick off your self-improvement journey?")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .shadow(radius: 2)

                Spacer()

                // Get Started Button
                Button(action: {
                    navigateToNext = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.horizontal, 30)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
            .padding()
            .background(
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationDestination(isPresented: $navigateToNext) {
                OnboardingPhysicalGoalsView(coreDataViewModel: coreDataViewModel)
            }
        }
    }
}

#Preview {
    OnboardingWelcomeView(coreDataViewModel: CoreDataViewModel())
}
