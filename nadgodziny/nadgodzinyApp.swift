import SwiftUI

@main
struct NadgodzinyApp: App {
    @StateObject private var viewModel = OvertimeViewModel()

    var body: some Scene {
            WindowGroup {
                SplashScreenView()
                    .environmentObject(viewModel)
                    .preferredColorScheme(viewModel.isDarkMode ? .dark : .light) // Ustaw preferencje kolorów
            }
        }
}
