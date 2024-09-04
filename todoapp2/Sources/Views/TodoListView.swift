import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var newTodoTitle: String = ""

    // Retro color scheme
    let retroColors = [Color(hex: "#FF6B6B"), Color(hex: "#4ECDC4"), Color(hex: "#45B7D1")]

    var body: some View {
        NavigationView {
            ZStack {
                // Retro background
                LinearGradient(gradient: Gradient(colors: retroColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    addTodoSection
                    todoList
                    achievementsSection
                }
            }
            .navigationTitle("Retro ToDos")
        }
    }

    private var addTodoSection: some View {
        HStack {
            TextField("New Todo", text: $newTodoTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
            Button(action: addTodo) {
                Image(systemName: "plus")
                    .padding()
                    .background(Circle().fill(retroColors[0]))
                    .foregroundColor(.white)
            }
        }
        .padding()
    }

    private var todoList: some View {
        List {
            ForEach(viewModel.todos) { todo in
                TodoRowView(todo: todo, viewModel: viewModel)
                    .listRowBackground(Color.white.opacity(0.5))
            }
            .onDelete(perform: deleteTodo)
        }
        .listStyle(PlainListStyle())
    }

    private var achievementsSection: some View {
        Group {
            if !viewModel.achievements.isEmpty {
                Text("Achievements")
                    .font(.headline)
                    .padding(.top)
                ForEach(viewModel.achievements, id: \.self) { achievement in
                    Text(achievement)
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .padding(.vertical, 2)
                }
            }
        }
    }

    private func addTodo() {
        if !newTodoTitle.isEmpty {
            viewModel.addTodo(title: newTodoTitle)
            newTodoTitle = ""
        }
    }

    private func deleteTodo(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.removeTodo(viewModel.todos[index])
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    @ObservedObject var viewModel: TodoViewModel

    var body: some View {
        HStack {
            Text(todo.title)
                .strikethrough(todo.isCompleted, color: .green)
            Spacer()
            Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleTodoCompletion(todo)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                viewModel.removeTodo(todo)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}

// Add this extension for hex color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}