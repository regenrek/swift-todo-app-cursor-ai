import Foundation

final class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var achievements: [String] = []

    private let userDefaults = UserDefaults.standard
    private let todosKey = "todos"
    private let achievementsKey = "achievements"

    init() {
        loadTodos()
        loadAchievements()
    }

    func addTodo(title: String) {
        let newTodo = Todo(title: title)
        todos.append(newTodo)
        saveTodos()
    }

    func updateTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
        }
    }

    func toggleTodoCompletion(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            if todos[index].isCompleted {
                let achievement = "Achievement Unlocked: Completed '\(todos[index].title)'"
                achievements.append(achievement)
                saveAchievements()
            }
            saveTodos()
        }
    }

    func removeTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
        saveTodos()
    }

    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            userDefaults.set(encoded, forKey: todosKey)
        }
    }

    private func loadTodos() {
        if let savedTodos = userDefaults.object(forKey: todosKey) as? Data {
            if let decodedTodos = try? JSONDecoder().decode([Todo].self, from: savedTodos) {
                todos = decodedTodos
            }
        }
    }

    private func saveAchievements() {
        userDefaults.set(achievements, forKey: achievementsKey)
    }

    private func loadAchievements() {
        if let savedAchievements = userDefaults.stringArray(forKey: achievementsKey) {
            achievements = savedAchievements
        }
    }
}