//
//  AddMacroView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 18/05/24.
//

import SwiftUI
import HealthKit

struct AddMacroView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var macros: [Macro]
//    @Binding var macros: [DailyMacro]
    @EnvironmentObject var healthStore: HKHealthStore

    @Binding var showModal: Bool
    @State private var food = ""
    @State private var date = Date()
    @State private var showAlert = false
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            VStack(spacing: 22){
                Text("Add Meals")
                    .multilineTextAlignment(.center)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "#FF5F00"))
                
                TextField("What did you eat today?", text: $food)
                    .padding()
                    // Mengubah warna teks
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke()
                            .foregroundColor(Color(hex: "#FF5F00"))
                    )
                
                DatePicker("Date", selection: $date)
                Button{
                    if food.count > 2{
                        sendItemToGPT()
                    }
                    
                } label: {
                    Text("Submit")
                        .bold()
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(hex: "#FF5F00")) // Mengubah warna latar belakang button
                        )
                }
                
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .alert("Oops! Invalid Food Item", isPresented: $showAlert){
                Text("Try Again")
            } message: {
                Text("We were unable to verify the food item. Please make sure you enter a valid food item.")
            }
            Button {
                showModal = false // Ubah nilai showModal ketika tombol ditekan
            } label: {
                 Image(systemName: "x.circle.fill")
                    .font(.title)
                    .foregroundColor(Color(hex: "#FF9F66"))
            }
            .font(.title)
            .foregroundColor(Color(hex: "#FF9F66"))
            
        }
       
    }
    
    private func sendItemToGPT(){
        Task {
                do {
                    let result = try await OpenAIService.shared.sendPromptToChatGPT(message: food)
                    // Handle result here
                    print("Received result: \(result)")
                    saveMacro(result)
                    dismiss()
                } catch {
                    if let openAIError = error as? OpenAIError{
                        switch openAIError {
                        case .noFunctionCall:
                            showAlert = true
                        case .unableToConvertStringIntoData:
                            print(error.localizedDescription)
                        }
                    } else {
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    private func saveMacro(_ result: MacroResult){
        let macro = Macro(food: result.food, createdAt: .now, date: .now, carbs: Int(result.carbs), protein: Int(result.protein), fats: Int(result.fats))
        print("Saving macro: \(macro)")
        macros.append(macro)
        modelContext.insert(macro)
        try? modelContext.save()
        
        // Write to HealthKit
        writeDietaryFat(value: result.fats, date: .now)
        writeDietaryProtein(value: result.protein, date: .now)
        writeDietaryCarbohydrates(value: result.carbs, date: .now)
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

    
}

#Preview {
    AddMacroView(macros: .constant([]), showModal: .constant(false))
}
