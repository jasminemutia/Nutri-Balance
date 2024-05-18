//
//  Macro.swift
//  Nutri Balance
//
//  Created by Jasmine Mutia Alifa on 18/05/24.
//

import Foundation
import SwiftData

@Model
final class Macro {
    let food: String
    let createdAt: Date
    let date: Date
    let carbs: Int
    let protein: Int
    let fats: Int
    
    init(food: String, createdAt: Date, date: Date, carbs: Int, protein: Int, fats: Int) {
        self.food = food
        self.createdAt = createdAt
        self.date = date
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
}
