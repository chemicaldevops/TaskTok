import SwiftUI

struct TaskCardView: View {
    let task: Task
    @State private var showCopiedFeedback = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if let copyText = task.copyText, !copyText.isEmpty {
                Text(copyText)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                    .onTapGesture {
                        UIPasteboard.general.string = copyText
                        
                        showCopiedFeedback = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            showCopiedFeedback = false
                        }
                    }
                    .overlay(
                        Text("Copied!")
                            .font(.caption)
                            .foregroundColor(.green)
                            .opacity(showCopiedFeedback ? 1 : 0)
                            .animation(.easeIn, value: showCopiedFeedback)
                    )
            }
            
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: 600)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: Task(text: "Make the first build", copyText: "swiftUI"))
            .preferredColorScheme(.dark)
    }
}
