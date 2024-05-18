//
//  AddMacroView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 18/05/24.
//

import SwiftUI

struct AddMacroView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
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
            Button("", systemImage: "x.circle.fill"){
                dismiss()
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
                    saveMacro(result)
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
        let macro = Macro(food: result.food, createdAt: .now, date: .now, carbs: result.carbs, protein: result.protein, fats: result.fats)
        modelContext.insert(macro)

    }
}

#Preview {
    AddMacroView()
}
