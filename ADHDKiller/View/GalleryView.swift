import SwiftUI

 struct GalleryView: View {
     @ObservedObject var viewModel: GalleryViewModel
     @Environment(\.dismiss) var dismiss
     
     var body: some View {
         NavigationView {
             ZStack {
                 if viewModel.currentTab == .active {
                     createTaskListView(tasks: viewModel.sortedActiveTasks, isCompleted: false)
                         .transition(.move(edge: .leading))
                 }
                 
                 if viewModel.currentTab == .completed {
                     createTaskListView(tasks: viewModel.sortedCompletedTasks, isCompleted: true)
                         .transition(.move(edge: .trailing))
                 }
             }
             .animation(.default, value: viewModel.currentTab)

             
             .navigationTitle(viewModel.currentTab.rawValue + " Tasks")
             .navigationBarTitleDisplayMode(.inline)
             .preferredColorScheme(.dark)
             .toolbar {
                 ToolbarItem(placement: .navigationBarLeading) {
                     Button("Done") { dismiss() }.foregroundColor(.white)
                 }
                 ToolbarItem(placement: .navigationBarTrailing) {
                     HStack(spacing: 15) {
                         Button { viewModel.currentTab = .active } label: {
                             Image(systemName: "list.bullet").opacity(viewModel.currentTab == .active ? 1.0 : 0.4)
                         }
                         Button { viewModel.currentTab = .completed } label: {
                             Image(systemName: "checkmark.circle").opacity(viewModel.currentTab == .completed ? 1.0 : 0.4)
                         }
                     }
                 }
             }
         }
     }


     
     @ViewBuilder
     private func createTaskListView(tasks: [Task], isCompleted: Bool) -> some View {
         List {
             ForEach(tasks) { task in
                 HStack {
                     VStack(alignment: .leading) {
                         Text(task.text)
                             .foregroundColor(.white)
                             .strikethrough(isCompleted, color: .gray)
                         Text(task.creationDate.formatted(date: .abbreviated, time: .shortened))
                             .font(.caption)
                             .foregroundColor(.gray)
                     }
                     Spacer()
                 }
                 .swipeActions(edge: .leading, allowsFullSwipe: false) {
                     if isCompleted {
                         Button {
                             viewModel.restoreTask(id: task.id)
                             dismiss()
                         } label: {
                             Label("Restore", systemImage: "arrow.uturn.backward")
                         }
                         .tint(.green)
                     }
                 }
                 .contentShape(Rectangle())
                 .onTapGesture {
                     if !isCompleted {
                         viewModel.mainViewModel.selectTask(id: task.id)
                         dismiss()
                     }
                 }

                 .allowsHitTesting(!isCompleted)

                 .contextMenu {
                     if !isCompleted{
                         Button {
                             viewModel.restoreTask(id: task.id)
                             dismiss()
                         } label: {
                             Label("Restore", systemImage: "arrow.uturn.backward")
                         }
                         .tint(.green)
                     }
                 }
             }
             .onDelete { offsets in
                 let currentTasks = (isCompleted ? viewModel.sortedCompletedTasks : viewModel.sortedActiveTasks)
                 viewModel.deleteTasks(at: offsets, in: currentTasks)
             }
         }
         .background(Color.black.edgesIgnoringSafeArea(.all))
         .scrollContentBackground(.hidden)
     }
 }

