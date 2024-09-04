//
//  todoapp2App.swift
//  todoapp2
//
//

import SwiftUI

@main
struct todoapp2App: App {
    var body: some Scene {
        WindowGroup {
            Text("Hello, World!")
                .onAppear {
                    print("Application started")
                }
        }
    }
}
