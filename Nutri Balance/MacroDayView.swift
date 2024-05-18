//
//  MacroDayView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 18/05/24.
//

import SwiftUI

struct MacroDayView: View {
    @State var macro: DailyMacro
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(macro.date.monthAndDay)
                    .font(.title2)
                Text(macro.date.year)
                    .font(.title3)
            }
            .frame(minWidth: 120)
            Spacer()
            
            HStack{
                VStack{
                    Text("Carbohydrates")
                        .multilineTextAlignment(.center)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .bold()
                        .font(.title2)
                        .foregroundColor(Color(hex: "#FFFAE6"))
                        
                    Image("carbohydrates")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85)
                    Text("\(macro.carbs) g")
                        .bold()
                        .font(.system(size: 21))
                        .foregroundColor(Color(hex: "#FFFAE6"))
                }
                .frame(width: 190, height: 170)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#FF9F66")) // Mengubah warna background
                )
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
                        .frame(width: 85)
                    Text("\(macro.protein) g")
                        .bold()
                        .font(.system(size: 21))
                        .foregroundColor(Color(hex: "#FFFAE6"))
                }
                .frame(width: 190, height: 170)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#FF9F66"))
                )
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
                        .frame(width: 85)
                    Text("\(macro.fats) g")
                        .bold()
                        .font(.system(size: 21))
                        .foregroundColor(Color(hex: "#FFFAE6"))
                }
                .frame(width: 190, height: 170)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#FF9F66"))
                )
                Spacer()
                
            }
        }
    }
}

#Preview {
    MacroDayView(macro: DailyMacro(date: .now, carbs: 123, protein: 80, fats: 30))
}
