//
//  TransactionAddingModalView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 16/11/25.
//

import SwiftUI

struct TransactionAddingModalView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: TransactionViewModel
    
    @State private var title = ""
    @State private var amount = ""
    @State private var type: TransactionType = .expense
    @State private var category: Category = .food
    @State private var date = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                        TextField("Enter title", text: $title)
                            .frame(height: 60)
                            .padding(.horizontal)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.headline)
                        TextField("0.00", text: $amount)
                            .frame(height: 60)
                            .padding(.horizontal)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.headline)
                        Picker("Type", selection: $type) {
                            Text("Expense").tag(TransactionType.expense)
                            Text("Income").tag(TransactionType.income)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                        Spacer()
                        Picker("Category", selection: $category) {
                            Text("Food").tag(Category.food)
                            Text("Transport").tag(Category.transport)
                            Text("Salary").tag(Category.salary)
                            Text("Entertainment").tag(Category.entertainment)
                            Text("Utilities").tag(Category.utilities)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Text("Date")
                                .font(.headline)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        ZStack(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Notes (optional)")
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(8)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(10)
                                .scrollContentBackground(.hidden)
                        }
                        .frame(height: 100)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .background(Color("TransactionsBackgroundColor"))
            .navigationTitle(Text("Add Transaction"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveTransaction()
                    } label: {
                        Text("Add")
                            .foregroundStyle(Color(.label))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accent)
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
            !title.isEmpty && !amount.isEmpty && Double(amount) != nil
        }
        
    private func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let transaction = TransactionModel(
            title: title,
            amount: amountValue,
            type: type,
            category: category,
            date: date,
            notes: notes.isEmpty ? nil : notes
        )
        
        viewModel.addTransaction(transaction)
        dismiss()
    }
}

#Preview {
    TransactionAddingModalView(viewModel: TransactionViewModel.preview)
        .preferredColorScheme(.dark)
}
