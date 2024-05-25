//
//  MacroDayView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 18/05/24.
//

import SwiftUI

struct MacroDayView: View {
    @State var macro: DailyMacro
    var onDelete: (DailyMacro) -> Void
    @State private var showAlert = false
    @State private var food: String = ""
    
    var body: some View {
        VStack{
            HStack {
                Text(macro.food)
                   .font(.title2)
                   .bold()
                   .foregroundColor(Color(hex: "#FFFAE6"))
                   .padding(.leading, 15)
              
                
                Spacer()
                
                VStack {
                   Text(macro.date.monthAndDay)
                       .font(.title3)
                       .bold()
                       .foregroundColor(Color(hex: "#FFFAE6"))
                       .padding(.trailing, 10)

                    Text(macro.date.year)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color(hex: "#FFFAE6"))
                }
                .padding(.trailing, 10)
                
            }
            
            Divider()
            
            HStack{
                Spacer()
                ZStack{
                    HStack{
                        VStack{
                           Text("Carbs")
                               .multilineTextAlignment(.center)
                               .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                               .bold()
                               .font(.title2)
                               .foregroundColor(Color(hex: "#FFFAE6"))
                        
                            Image("carbohydrates")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                        
                            Text("\(macro.carbs) g")
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(Color(hex: "#FFFAE6"))
                       }
                        .padding(.leading, 15)
                        
                        Spacer()
                        VStack{
                            Text("Protein")
                                .multilineTextAlignment(.center)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                .bold()
                                .font(.title2)
                                .foregroundColor(Color(hex: "#FFFAE6"))
                            Image("proteins")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            Text("\(macro.protein) g")
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(Color(hex: "#FFFAE6"))
                        }
                        Spacer()
                        
                        VStack{
                            Text("Fats")
                                .multilineTextAlignment(.center)
                                .bold()
                                .font(.title2)
                                .foregroundColor(Color(hex: "#FFFAE6"))
                            Image("fats")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            Text("\(macro.fats) g")
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(Color(hex: "#FFFAE6"))
                        }
                        .padding(.trailing, 15)
    
                    }
                    Spacer()
                }
   
                Spacer()
                
            }
           
        }
        .frame(width: 360, height: 250)
        .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#FF9F66"))
        )
        .swipeActions {
                   Button(role: .destructive) {
                       showAlert = true
                   } label: {
                       Label("Delete", systemImage: "trash")
                   }
               }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete Item"),
                message: Text("Are you sure you want to delete this item?"),
                primaryButton: .destructive(Text("Delete")) {
                    onDelete(macro)
                },
                secondaryButton: .cancel()
                )
        }
    }
}

#Preview {
    MacroDayView(macro: DailyMacro(date: .now, carbs: 123, protein: 80, fats: 30, food: "Cheese Cake")) { _ in }
}
