//
//  Programming_Assignment1App.swift
//  Programming_Assignment1
//
//  Created by Finn Goldmann on 08/10/2026.
//

import SwiftUI
import SwiftData

@main
struct Programming_Assignment1App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
