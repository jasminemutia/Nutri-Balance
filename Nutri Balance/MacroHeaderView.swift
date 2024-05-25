//
//  MacroItemView.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 18/05/24.
//

import SwiftUI

struct MacroHeaderView: View {
    var carbs: Int
    var fats: Int
    var proteins: Int
    
    var body: some View {
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
                            .frame(width: 85)
                                    
                        Text("\(carbs) g")
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(Color(hex: "#FFFAE6"))
                   }
                    .padding(.leading, 60)
                    
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
                        Text("\(proteins) g")
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
                            .frame(width: 85)
                        Text("\(fats) g")
                            .bold()
                            .font(.system(size: 25))
                            .foregroundColor(Color(hex: "#FFFAE6"))
                    }
                    .padding(.trailing, 60)
                   
                   
                }
                Spacer()
            }
            .frame(width: 750, height: 180)
            .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#FF9F66"))
            )
        
            Spacer()
            
        }
    }
}

//#Preview {
//    MacroHeaderView(carbs: .constant(204), fats: .constant(72), proteins: .constant(59))
//}
