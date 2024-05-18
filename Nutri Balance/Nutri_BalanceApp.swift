//
//  Nutri_BalanceApp.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 17/05/24.
//

import SwiftUI
import SwiftData

@main
struct Nutri_BalanceApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Macro.self,
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
            MacroView()
        }
        .modelContainer(sharedModelContainer)
    }
}
