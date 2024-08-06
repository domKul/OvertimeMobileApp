import SwiftUI

struct OvertimeRecordsView: View {
    @StateObject private var viewModel = OvertimeViewModel()
    @State private var isFilterSheetPresented = false
    @State private var isAddOvertimeSheetPresented = false
    @State private var filterYear: String = ""
    @State private var filterStatus: String = ""
    @State private var showSuccessCheckmark = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Overtime Records")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                HStack {
                    Button(action: {
                        isFilterSheetPresented = true
                    }) {
                        Text("Show Filter Options")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        isAddOvertimeSheetPresented = true
                    }) {
                        Text("Add Overtime")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                }
                
                if viewModel.overtimes.isEmpty {
                    Text("No overtimes found.")
                        .font(.headline)
                        .padding()
                        .onAppear {
                            filterYear = ""
                            filterStatus = ""
                        }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.overtimes) { overtime in
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Creation Date:")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                        Text(overtime.creationDate)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 100)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Overtime Date:")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                        Text(overtime.overtimeDate)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 100)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Status:")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                        Text(overtime.status)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 80)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Duration:")
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                        Text("\(overtime.duration) hours")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 80)
                                }
                                .padding(5)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
            .padding(10)
            .navigationTitle("Overtime Records")
            .sheet(isPresented: $isFilterSheetPresented) {
                FilterSheet(viewModel: viewModel, filterYear: $filterYear, filterStatus: $filterStatus, onApply: {
                    let year = Int(filterYear)
                    let status = filterStatus.isEmpty ? nil : filterStatus
                    
                    if year == nil && status == nil {
                        viewModel.fetchOvertimes()
                    } else {
                        viewModel.fetchFilteredOvertimes(year: year, status: status)
                    }
                    
                    isFilterSheetPresented = false
                })
            }
            .sheet(isPresented: $isAddOvertimeSheetPresented, onDismiss: {
                if showSuccessCheckmark {
                    withAnimation {
                        showSuccessCheckmark = false
                    }
                }
            }) {
                AddOvertimeSheet(viewModel: viewModel, onSave: { success in
                    isAddOvertimeSheetPresented = false
                    if success {
                        withAnimation {
                            showSuccessCheckmark = true
                        }
                    }
                })
            }
            
            if showSuccessCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .transition(.scale)
                    .zIndex(1) // Ensure it appears above other content
            }
        }
    }
}

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

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OvertimeRecordsView()
    }
}
