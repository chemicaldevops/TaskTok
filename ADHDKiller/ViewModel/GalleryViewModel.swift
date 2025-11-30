import Foundation
import SwiftUI
import Combine

enum GalleryTab: String, CaseIterable, Identifiable {
    case active = "Active"
    case completed = "Completed"
    var id: String { self.rawValue }
}

class GalleryViewModel: ObservableObject {
    
    @ObservedObject var mainViewModel: TaskViewModel
    @Published var currentTab: GalleryTab = .active
    
    init(mainViewModel: TaskViewModel) {
        self.mainViewModel = mainViewModel
    }

    var allTasks: [Task] {
        return mainViewModel.tasks
    }
    
    var activeTasks: [Task] {
        return allTasks.filter { $0.isCompleted == false }
    }
    
    var completedTasks: [Task] {
        return allTasks.filter { $0.isCompleted == true }
    }
        
    func deleteTasks(at offsets: IndexSet, in taskArray: [Task]) {
        offsets.forEach { index in
            let taskToDelete = taskArray[index]
            mainViewModel.deleteTask(id: taskToDelete.id)
        }
    }

    func restoreTask(id: UUID) {
        mainViewModel.restoreTask(id: id)
    }

    func permanentDeleteTask(id: UUID) {
        mainViewModel.deleteTask(id: id)
    }
    
    var sortedActiveTasks: [Task] {
        return activeTasks.sorted { $0.creationDate > $1.creationDate }
    }
    
    var sortedCompletedTasks: [Task] {
        return completedTasks.sorted { $0.creationDate > $1.creationDate }
    }
}

