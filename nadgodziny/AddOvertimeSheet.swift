import SwiftUI
import Combine

struct AddOvertimeSheet: View {
    @ObservedObject var viewModel: OvertimeViewModel
    @State private var overtimeDate = Date()
    @State private var selectedStatus = "nadgodziny" // Default to "nadgodziny"
    @State private var duration = ""
    @State private var isSaving = false
    @State private var saveSuccessful: Bool? = nil // To track success or failure of the save operation
    var onSave: (Bool) -> Void

    @FocusState private var isDurationFieldFocused: Bool
    @State private var keyboardHeight: CGFloat = 0

    // Options for the status
    private let statusOptions = ["nadgodziny", "zlecenie"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    DatePicker(
                        "Overtime Date",
                        selection: $overtimeDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle()) // Uses a more graphical, calendar-style date picker
                    .padding()

                    Picker("Status", selection: $selectedStatus) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Uses a segmented control style
                    .padding()

                    TextField("Duration (hours)", text: $duration)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                        .focused($isDurationFieldFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isDurationFieldFocused = false
                                }
                            }
                        }

                    Button(action: saveOvertime) {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .disabled(isSaving)

                    Spacer()
                        .frame(height: keyboardHeight)
                }
                .padding()
            }
            .navigationTitle("Add Overtime")
            .navigationBarItems(trailing: Button("Close") {
                onSave(false)
            })
            .onAppear {
                startObservingKeyboard()
            }
            .onDisappear {
                stopObservingKeyboard()
            }
        }
    }

    private func saveOvertime() {
        guard let duration = Int(duration) else {
            // Handle invalid duration
            self.saveSuccessful = false
            return
        }

        // Format date to a string in ISO 8601 format
        let dateFormatter = ISO8601DateFormatter()
        let formattedDate = dateFormatter.string(from: overtimeDate)

        let dto = OvertimeCreateDto(
            overtimeDate: formattedDate,
            status: selectedStatus,
            duration: duration
        )

        isSaving = true
        viewModel.addOvertime(dto) { success in
            isSaving = false
            saveSuccessful = success
            if success {
                onSave(true)
            }
        }
    }

    private func startObservingKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }

    private func stopObservingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
