
struct FilterSheet: View {
    @ObservedObject var viewModel: OvertimeViewModel
    @Binding var filterYear: String
    @Binding var filterStatus: String
    var onApply: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Year", text: $filterYear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
                TextField("Status", text: $filterStatus)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    onApply()
                }) {
                    Text("Filter")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                
                Spacer()
            }
            .navigationTitle("Filter Options")
            .navigationBarItems(trailing: Button("Close") {
                onApply()
            })
        }
    }
}
