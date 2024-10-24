import SwiftUIstruct SplashScreenView: View {    @State private var isActive = false    @State private var opacity = 0.0        // Pass in the coreDataViewModel from the App entry point    @ObservedObject var coreDataViewModel: CoreDataViewModel    var body: some View {        ZStack {            if isActive {                // Check if onboarding is completed                if coreDataViewModel.isOnboardingCompleted() {                    ContentView(coreDataViewModel: coreDataViewModel)                } else {                    OnboardingWelcomeView(coreDataViewModel: coreDataViewModel)                }            } else {                // Splash screen design                LinearGradient(                    gradient: Gradient(colors: [Color.green, Color.blue]),                    startPoint: .topLeading,                    endPoint: .bottomTrailing                )                .edgesIgnoringSafeArea(.all)                // App Name                Text("Balance")                    .font(.system(size: 48, weight: .bold, design: .default))                    .foregroundColor(.white)                    .opacity(opacity)                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)            }        }        .onAppear {            // Fade-in Animation            withAnimation(.easeIn(duration: 1.5)) {                opacity = 1.0            }            // Delay transition to main app flow            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {                withAnimation {                    isActive = true                }            }        }    }}#Preview {    SplashScreenView(coreDataViewModel: CoreDataViewModel())}