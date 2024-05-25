//
//  MacroView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 17/05/24.
//

import SwiftUI
import SwiftData
import HealthKit

struct DailyMacro: Identifiable {
    let id = UUID()
    let date: Date
    let carbs: Int
    let protein: Int
    let fats: Int
    var food: String
}


struct MacroView: View {
    @EnvironmentObject var healthStore: HKHealthStore
    @Environment(\.modelContext) var modelContext
    
    @State var carbs = 204
    @State var proteins = 59
    @State var fats = 72
    
    @State var macros: [Macro] = []
    @State var dailyMacros:[DailyMacro] = []
    @State var showTextField = false
    @State var food = ""
    
    @State var showModal = false
    @State private var macroToDelete: DailyMacro? // Tambahkan state variable ini
    @State private var showDeleteAlert = false //
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
            NavigationStack {
                ScrollView {
                    ZStack {
                        VStack{
                            Text("Maximum Daily Consume")
                                .multilineTextAlignment(.center)
                                .bold()
                                .font(.largeTitle)
                                .foregroundColor(Color(hex: "#FF5F00"))
                                .padding(.top, 5)
                            
                           MacroHeaderView(carbs: carbs, fats: fats, proteins: proteins)
                            .padding(.bottom, 50)
                            
                            VStack{
                                Text("Meals History")
                                    .multilineTextAlignment(.center)
                                    .bold()
                                    .font(.largeTitle)
                                    .foregroundColor(Color(hex: "#FF5F00"))
                                
                                LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(dailyMacros) { macro in
                                        MacroDayView(macro: macro) { macroToDelete in
                                            showAlertToDeleteMacro(macroToDelete)
                                    }
                                    .gesture(
                                        DragGesture(minimumDistance: 50)
                                            .onEnded { _ in
                                                macroToDelete = macro
                                                showDeleteAlert = true
                                            }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
            .toolbar{
                ToolbarItem{
                    Button{
//                        showTextField = true
                        showModal = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color(hex: "002379"))
                    }
                }
            }
            .onAppear{
                fetchDailyMacros()
                readDietaryData()
            }
            .onChange(of: macros){ _, _ in
                fetchDailyMacros()
                }
            }
            .overlay(
                Group {
                   if showModal {
                       Color.black.opacity(0.4)
                       .edgesIgnoringSafeArea(.all)
                 VStack {
                     AddMacroView(macros: $macros, showModal: $showModal)
                            .frame(width: 550, height: 320) // Atur ukuran modal
                            .padding(.horizontal, 15)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 20)
                    }
                  }
                }
            )
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Meals"),
                    message: Text("Are you sure you want to delete?"),
                    primaryButton: .destructive(Text("Delete")) {
                    if let macroToDelete = macroToDelete {
                        deleteDailyMacro(macroToDelete)
                    }
                },
                secondaryButton: .cancel()
                )
            }

}
    
    private func fetchDailyMacros() {
           dailyMacros = macros.map { macro in
               DailyMacro(date: macro.date, carbs: macro.carbs, protein: macro.protein, fats: macro.fats, food: macro.food)
           }
           .sorted { $0.date > $1.date }
       }

        
        private func fetchTodaysMacros() {
            if let firstDay = dailyMacros.first, Calendar.current.startOfDay(for: firstDay.date) == Calendar.current.startOfDay(for: .now) {
                carbs = firstDay.carbs
                proteins = firstDay.protein
                fats = firstDay.fats
            }
        }
        
        private func readDietaryData() {
            readDietaryFat()
            readDietaryProtein()
            readDietaryCarbohydrates()
        }
        
        private func readDietaryFat() {
            readQuantityData(for: .dietaryFatTotal, unit: .gram(), label: "Dietary Fat")
        }
        
        private func readDietaryProtein() {
            readQuantityData(for: .dietaryProtein, unit: .gram(), label: "Dietary Protein")
        }
        
        private func readDietaryCarbohydrates() {
            readQuantityData(for: .dietaryCarbohydrates, unit: .gram(), label: "Dietary Carbohydrates")
        }
        
        private func readQuantityData(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, label: String) {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
                print("Invalid quantity type identifier")
                return
            }
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let sampleQuery = HKSampleQuery(sampleType: quantityType,
                                            predicate: get24hPredicate(),
                                            limit: HKObjectQueryNoLimit,
                                            sortDescriptors: [sortDescriptor]) { (query, results, error) in
                guard let samples = results as? [HKQuantitySample] else {
                    print(error ?? "Unknown error")
                    return
                }
                for sample in samples {
                    let value = sample.quantity.doubleValue(for: unit)
                    print("\(label): \(value) \(unit.unitString)")
                }
            }
            healthStore.execute(sampleQuery)
        }
        
        private func get24hPredicate() -> NSPredicate {
            let today = Date()
            let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
            return HKQuery.predicateForSamples(withStart: startDate, end: today, options: [])
        }
        
        private func writeDietaryData(value: Double, type: HKQuantityTypeIdentifier, unit: HKUnit, date: Date) {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: type) else {
                print("Invalid quantity type identifier")
                return
            }
            
            let quantity = HKQuantity(unit: unit, doubleValue: value)
            let sample = HKQuantitySample(type: quantityType, quantity: quantity, start: date, end: date)
            
            healthStore.save(sample) { (success, error) in
                if let error = error {
                    print("Error saving \(type): \(error.localizedDescription)")
                } else {
                    print("Successfully saved \(type)")
                }
            }
        }
        
        private func writeDietaryFat(value: Double, date: Date) {
            writeDietaryData(value: value, type: .dietaryFatTotal, unit: .gram(), date: date)
        }
        
        private func writeDietaryProtein(value: Double, date: Date) {
            writeDietaryData(value: value, type: .dietaryProtein, unit: .gram(), date: date)
        }
        
        private func writeDietaryCarbohydrates(value: Double, date: Date) {
            writeDietaryData(value: value, type: .dietaryCarbohydrates, unit: .gram(), date: date)
        }
    
    
    private func showAlertToDeleteMacro(_ macroToDelete: DailyMacro) {
            self.macroToDelete = macroToDelete
            self.showDeleteAlert = true
        }
        
        private func deleteDailyMacro(_ dailyMacro: DailyMacro) {
            let macrosToDelete = macros.filter {
                Calendar.current.startOfDay(for: $0.date) == dailyMacro.date
            }
            
            for macro in macrosToDelete {
                modelContext.delete(macro)
                
                // Kurangi jumlah makronutrien di HealthKit
                reduceDietaryFat(value: Double(macro.fats), date: macro.date)
                reduceDietaryProtein(value: Double(macro.protein), date: macro.date)
                reduceDietaryCarbohydrates(value: Double(macro.carbs), date: macro.date)
            }
            
            try? modelContext.save()
            
            // Update array lokal
            macros.removeAll { macro in
                Calendar.current.startOfDay(for: macro.date) == dailyMacro.date
            }
            dailyMacros.removeAll { $0.id == dailyMacro.id }
        }
       
       private func reduceDietaryData(value: Double, type: HKQuantityTypeIdentifier, unit: HKUnit, date: Date) {
           guard let quantityType = HKObjectType.quantityType(forIdentifier: type) else {
               print("Invalid quantity type identifier")
               return
           }
           
           let quantity = HKQuantity(unit: unit, doubleValue: value)
           let sample = HKQuantitySample(type: quantityType, quantity: quantity, start: date, end: date)
           
           healthStore.delete([sample]) { (success, error) in
               if let error = error {
                   print("Error deleting \(type): \(error.localizedDescription)")
               } else {
                   print("Successfully deleted \(type)")
               }
           }
       }
       
       private func reduceDietaryFat(value: Double, date: Date) {
           reduceDietaryData(value: value, type: .dietaryFatTotal, unit: .gram(), date: date)
       }
       
       private func reduceDietaryProtein(value: Double, date: Date) {
           reduceDietaryData(value: value, type: .dietaryProtein, unit: .gram(), date: date)
       }
       
       private func reduceDietaryCarbohydrates(value: Double, date: Date) {
           reduceDietaryData(value: value, type: .dietaryCarbohydrates, unit: .gram(), date: date)
       }

}


#Preview {
    MacroView().environmentObject(HKHealthStore())
}




