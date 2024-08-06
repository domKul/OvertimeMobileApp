import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var viewModel: OvertimeViewModel
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainView()
                .environmentObject(viewModel) // Przekazujemy obiekt środowiskowy do MainView
        } else {
            VStack {
                VStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    Text("Overtimes Manager")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(OvertimeViewModel()) // Dodajemy obiekt środowiskowy do podglądu
}
