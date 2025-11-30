import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var taskText: String = ""
    @State private var copyText: String = ""
    
    var isSaveButtonDisabled: Bool {
        taskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    TextEditor(text: $taskText)
                        .frame(height: 100)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .colorScheme(.dark)
                        .padding(.horizontal)
                    
                    TextField("Text to copy (Optional)", text: $copyText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .colorScheme(.dark)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addTask(text: taskText, copyText: copyText)
                        dismiss()
                    }
                    .foregroundColor(isSaveButtonDisabled ? .gray : .white)
                    .disabled(isSaveButtonDisabled)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
