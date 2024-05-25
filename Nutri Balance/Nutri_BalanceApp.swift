//
//  Nutri_BalanceApp.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 17/05/24.
//

import SwiftUI
import SwiftData
import HealthKit

@main
struct Nutri_BalanceApp: App {
    
    private let healthStore: HKHealthStore
    
    init() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("This app requires a device that supports HealthKit") }
        healthStore = HKHealthStore()
        requestHealthkitPermissions()
    }
    
    private func requestHealthkitPermissions() {
        
        let sampleTypesToRead = Set([
            HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
            HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!
        ])
        
        let sampleTypesToWrite = Set([
                   HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
                   HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
                   HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!
        ])
               
        healthStore.requestAuthorization(toShare: sampleTypesToWrite, read: sampleTypesToRead) { (success, error) in
                print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
        }
    }
    
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
            MacroView().environmentObject(healthStore)
        }
        .modelContainer(sharedModelContainer)
    }
}

extension HKHealthStore: ObservableObject {}
