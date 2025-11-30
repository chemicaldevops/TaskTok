 import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var offset: CGSize = .zero
    
    @State private var isShowingAddTaskView = false
    @State private var isShowingGalleryView = false
    @State private var isShowingSettingsView = false
    @State private var isShowingEditTaskView = false
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                
                
                if let task = viewModel.currentTask {
                    TaskCardView(task: task)
                        .offset(offset)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: offset)
                    
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged { value in self.offset = value.translation }
                                .onEnded { value in handleGesture(value: value) }
                        )
                        .onLongPressGesture {
                            isShowingEditTaskView = true
                            HapticFeedbackManager.light()
                        }
                        .padding(.vertical, 30)
                    
                } else {
                    // Пустой стейт
                    Spacer()
                    Text("All tasks completed! 🎉")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(.top, 150)
                    Spacer()
                }
                
                HStack {
                    Button { isShowingGalleryView = true } label: {
                        Image(systemName: "list.bullet").font(.largeTitle)
                    }
                    
                    Spacer()
                    
                    Button { isShowingAddTaskView = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // КНОПКА НАСТРОЕК (gear)
                    Button { isShowingSettingsView = true } label: {
                        Image(systemName: "gear").font(.largeTitle)
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }

            .frame(minHeight: UIScreen.main.bounds.height)
            
        }
        .preferredColorScheme(.dark)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
        .sheet(isPresented: $isShowingGalleryView) {
            GalleryView(viewModel: GalleryViewModel(mainViewModel: viewModel))
        }
        .sheet(isPresented: $isShowingAddTaskView) {
            AddTaskView(viewModel: viewModel)
        }
        .sheet(isPresented: $isShowingSettingsView) {
            NavigationView {
                Text("Settings View (WIP)").foregroundColor(.white).navigationTitle("Settings")
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $isShowingEditTaskView) {
            if let task = viewModel.currentTask {
                EditTaskView(viewModel: viewModel, taskToEdit: task)
            }
        }
    }
    
    
    private func handleGesture(value: DragGesture.Value) {
        let horizontal = abs(value.translation.width)
        let vertical = abs(value.translation.height)
        let threshold: CGFloat = 80
        
        if value.translation.height < -threshold && vertical > horizontal {
            viewModel.goToNextTask()
            self.offset = .zero
        }
        else if value.translation.height > threshold && vertical > horizontal {
            viewModel.goToPreviousTask()
            self.offset = .zero
        }
        else if value.translation.width < -threshold && horizontal > vertical {
            viewModel.completeCurrentTask()
            self.offset = .zero
        }
        else {
            self.offset = .zero
        }
    }
}


