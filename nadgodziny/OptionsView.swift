import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var viewModel: OvertimeViewModel

    var body: some View {
        VStack {
            Text("Options")
                .font(.largeTitle)
                .padding(.top, 20)
            
            Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                .padding()
                .onChange(of: viewModel.isDarkMode) { value in
                    // Apply dark mode setting to the application
                    if let window = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows.first {
                        window.overrideUserInterfaceStyle = value ? .dark : .light
                    }
                }
        }
        .padding(100)
        .padding(.top,-450)
        .navigationTitle("Options")
    }
}

#Preview {
    OptionsView()
        .environmentObject(OvertimeViewModel()) // Add environment object for preview
}
