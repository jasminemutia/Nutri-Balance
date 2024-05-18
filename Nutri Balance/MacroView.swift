//
//  MacroView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 17/05/24.
//

import SwiftUI
import SwiftData

struct DailyMacro: Identifiable {
    let id = UUID()
    let date: Date
    let carbs: Int
    let protein: Int
    let fats: Int
}

struct MacroView: View {
    @Environment(\.modelContext) var modelContext
    @State var carbs = 204
    @State var proteins = 59
    @State var fats = 72
    
    @Query var macros: [Macro]
    @State var dailyMacros = [DailyMacro]()
    @State var showTextField = false
    @State var food = ""
    
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
                                
                                ForEach(dailyMacros) { macro in
                                    HStack {
                                        MacroDayView(macro: macro)
                                       
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
                .toolbar{
                    ToolbarItem{
                        Button{
                            showTextField = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color(hex: "002379"))
                        }
                    }
                }
                .sheet(isPresented: $showTextField) {
                    AddMacroView()
                        .presentationDetents([.fraction(0.1)])
                }
                .onAppear{
                    fetchDailyMacros()
//                    fetchTodaysMacros()
                }
                .onChange(of: macros){ _, _ in
                    fetchDailyMacros()
//                    fetchTodaysMacros()
                }
            }
            
    }
    
    private func fetchDailyMacros(){
        let dates: Set<Date> = Set(macros.map({ Calendar.current.startOfDay(for: $0.date)}))
        
        var dailyMacros = [DailyMacro]()
        
        for date in dates{
            let filterMacros = macros.filter({ Calendar.current.startOfDay(for: $0.date) == date})
            let carbs: Int = filterMacros.reduce(0, { $0 + $1.carbs })
            let protein: Int = filterMacros.reduce(0, { $0 + $1.protein })
            let fats: Int = filterMacros.reduce(0, { $0 + $1.fats })
            
            let macro = DailyMacro(date: date, carbs: carbs, protein: protein, fats: fats)
            dailyMacros.append(macro)
        }
       
        self.dailyMacros =  dailyMacros.sorted(by: {$0.date > $1.date})
    }
    
//    private func saveMacro(_ result: MacroResult){
//        let macro = Macro(food: result.food, createdAt: .now, date: .now, carbs: result.carbs, protein: result.protein, fats: result.fats)
//        modelContext.insert(macro)
//
//    }
    
    private func fetchTodaysMacros(){
        if let firstDay = dailyMacros.first, Calendar.current.startOfDay(for: firstDay.date) == Calendar.current.startOfDay(for: .now){
            carbs = firstDay.carbs
            proteins = firstDay.protein
            fats = firstDay.fats
        }
        
    }
}


#Preview {
    MacroView()
}
