import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = TaskDataStore.loadTasks()
    @Published var currentTaskIndex: Int = 0

    var activeTasks: [Task] {
        return tasks.filter { $0.isCompleted == false }
    }

    var currentTask: Task? {
        guard activeTasks.indices.contains(currentTaskIndex) else { return nil }
        return activeTasks[currentTaskIndex]
    }
    
    


    func selectTask(id: UUID) {
        if let indexInActiveTasks = activeTasks.firstIndex(where: { $0.id == id }) {
            
            currentTaskIndex = indexInActiveTasks
            
            HapticFeedbackManager.light()
            
        } else {
            currentTaskIndex = 0
        }
    }
    

    func restoreTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted = false
            
            TaskDataStore.saveTasks(tasks)
            HapticFeedbackManager.success()
            
            selectTask(id: id)
        }
    }
    
    func completeCurrentTask() {
        guard let taskID = currentTask?.id else {
            return
        }

        if let indexInAllTasks = tasks.firstIndex(where: { $0.id == taskID }) {
            
            tasks[indexInAllTasks].isCompleted = true
            
            TaskDataStore.saveTasks(tasks)
            
            goToNextTask()
            
            HapticFeedbackManager.success()
        }
    }

    func goToNextTask() {
        guard !activeTasks.isEmpty else {
            currentTaskIndex = 0
            HapticFeedbackManager.light()
            return
        }
        
        currentTaskIndex = (currentTaskIndex + 1) % activeTasks.count
        
        HapticFeedbackManager.light()
    }


    func goToPreviousTask() {
        if currentTaskIndex > 0 {
            currentTaskIndex -= 1
            HapticFeedbackManager.light()
        } else {
            HapticFeedbackManager.light()
        }
    }

    
    func addTask(text: String, copyText: String? = nil, link: String? = nil, imageUrl: String? = nil) {
        let newTask = Task(text: text, imageUrl: imageUrl, link: link, copyText: copyText)
        tasks.insert(newTask, at: 0)
        currentTaskIndex = 0
        TaskDataStore.saveTasks(tasks)
    }
    
    func deleteTask(at index: Int) {
        guard index < activeTasks.count else { return }
        
        tasks.remove(at: index)
        TaskDataStore.saveTasks(tasks)
        
        if currentTaskIndex >= activeTasks.count && activeTasks.count > 0 {
            currentTaskIndex = activeTasks.count - 1
        } else if tasks.isEmpty {
            currentTaskIndex = 0
        }
    }

    func updateTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            
            TaskDataStore.saveTasks(tasks)
            HapticFeedbackManager.success()
        }
    }

    func deleteTask(id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks.remove(at: index)
            
            if currentTaskIndex >= activeTasks.count && activeTasks.count > 0 {
                currentTaskIndex = activeTasks.count - 1
            } else if tasks.isEmpty {
                currentTaskIndex = 0
            }
            
            TaskDataStore.saveTasks(tasks)
            HapticFeedbackManager.success()
        }
    }
}
