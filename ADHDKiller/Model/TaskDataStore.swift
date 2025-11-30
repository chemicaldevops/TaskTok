import Foundation

struct TaskDataStore {
    
    static private let filename = "tasks.json"
    
    static private var fileURL: URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not find documents directory")
        }
        return url.appendingPathComponent(filename)
    }
    
    static func saveTasks(_ tasks: [Task]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(tasks)
            
            try data.write(to: fileURL)
            print("Tasks successfully saved to: \(fileURL.path)")
        } catch {
            print("Error saving tasks: \(error.localizedDescription)")
        }
    }
    
    
    static func loadTasks() -> [Task] {
        let sampleTasks = [
            Task(text: "Hi! Swipe me left to finish", copyText: "Tinder Task App"),
            Task(text: "Swipe me up to see the next task"),
            Task(text: "Add a new task by clicking on '+'", link: "http://t.me"),
        ]
        
        guard let data = try? Data(contentsOf: fileURL) else {
            return sampleTasks
        }
        
        do {
            let decoder = JSONDecoder()
            let tasks = try decoder.decode([Task].self, from: data)
            print("Tasks loaded successfully.")
            return tasks
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
            return sampleTasks
        }
    }
}
