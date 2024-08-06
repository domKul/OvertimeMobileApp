import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = OvertimeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                AnimatedCircle(isServerAvailable: $viewModel.isServerAvailable)
                    .frame(width: 100, height: 100)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                
                Text("Server Status")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                NavigationLink(destination: OvertimeRecordsView()) {
                    Text("Go to Overtime Records")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
                NavigationLink(destination: OptionsView()) {
                    Text("Options")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 0)

                Spacer()

                if viewModel.statistics.isEmpty {
                    Text("Loading statistics...")
                        .padding()
                } else {
                    VStack {
                        Text("Statistics")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(viewModel.statistics.sorted(by: { $0.key < $1.key }), id: \.key) { year, totalHours in
                            Text("Year: \(year), Total Hours: \(totalHours)")
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
            }
            .padding(.bottom, 100)
            .onAppear {
                viewModel.checkServerStatus()
                viewModel.fetchStatistics()
            }
        }
    }
}

struct AnimatedCircle: View {
    @Binding var isServerAvailable: Bool
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .fill(isServerAvailable ? Color.blue : Color.red)
            .scaleEffect(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 0.5 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    MainView()
        .environmentObject(OvertimeViewModel())
}
