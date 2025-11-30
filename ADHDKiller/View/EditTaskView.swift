import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    let taskToEdit: Task
    
    @State private var task: Task
    
    init(viewModel: TaskViewModel, taskToEdit: Task) {
        self.viewModel = viewModel
        self.taskToEdit = taskToEdit
        _task = State(initialValue: taskToEdit)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Text", text: $task.text)
                    
                    TextField("Copy Text", text: $task.copyText.bound)
                }
                
                Section {
                    Button("DELETE TASK", role: .destructive) {
                        viewModel.deleteTask(id: task.id)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateTask(task: task)
                        dismiss()
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue.isEmpty ? nil : newValue }
    }
}
