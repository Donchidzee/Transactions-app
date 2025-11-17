//
//  TransactionModal.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 05/11/25.
//

import Foundation

enum TransactionType: String {
    case income
    case expense
}

enum Category: String {
    case food = "Food"
    case transport = "Transport"
    case salary = "Salary"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
}

struct TransactionModel: Identifiable {
    let id: UUID = UUID()
    var title: String
    var amount: Double
    var type: TransactionType
    var category: Category
    var date: Date
    var notes: String?
}

extension TransactionModel {
    var formattedAmount: String {
        let sign = type == .income ? "+" : "-"
        let formatted = amount.formatted(.currency(code: "EUR"))
        return "\(sign)\(formatted)"
    }
}

extension TransactionModel {
    static let mockData: [TransactionModel] = [
        TransactionModel(
            title: "Grocery Shopping",
            amount: 85.50,
            type: .expense,
            category: .food,
            date: Date().addingTimeInterval(-86400 * 2),
            notes: "Weekly groceries from Whole Foods"
        ),
        TransactionModel(
            title: "Monthly Salary",
            amount: 5000.00,
            type: .income,
            category: .salary,
            date: Date().addingTimeInterval(-86400 * 5),
            notes: nil
        ),
        TransactionModel(
            title: "Uber Ride",
            amount: 23.40,
            type: .expense,
            category: .transport,
            date: Date().addingTimeInterval(-86400 * 1),
            notes: "Trip to downtown"
        ),
        TransactionModel(
            title: "Netflix Subscription",
            amount: 15.99,
            type: .expense,
            category: .entertainment,
            date: Date().addingTimeInterval(-86400 * 7),
            notes: "Monthly subscription"
        ),
        TransactionModel(
            title: "Electricity Bill",
            amount: 120.00,
            type: .expense,
            category: .utilities,
            date: Date().addingTimeInterval(-86400 * 10),
            notes: nil
        ),
        TransactionModel(
            title: "Restaurant Dinner",
            amount: 67.80,
            type: .expense,
            category: .food,
            date: Date().addingTimeInterval(-86400 * 3),
            notes: "Dinner with friends"
        ),
        TransactionModel(
            title: "Freelance Project",
            amount: 800.00,
            type: .income,
            category: .salary,
            date: Date().addingTimeInterval(-86400 * 15),
            notes: "Website design project"
        ),
        TransactionModel(
            title: "Gas Station",
            amount: 45.00,
            type: .expense,
            category: .transport,
            date: Date().addingTimeInterval(-86400 * 4),
            notes: nil
        ),
        TransactionModel(
            title: "Cinema Tickets",
            amount: 28.00,
            type: .expense,
            category: .entertainment,
            date: Date().addingTimeInterval(-86400 * 6),
            notes: "Movie night"
        ),
        TransactionModel(
            title: "Internet Bill",
            amount: 65.00,
            type: .expense,
            category: .utilities,
            date: Date().addingTimeInterval(-86400 * 12),
            notes: "Monthly fiber internet"
        )
    ]
}

