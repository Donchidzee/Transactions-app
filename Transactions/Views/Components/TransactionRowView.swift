//
//  TransactionRowView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 16/11/25.
//

import SwiftUI

struct TransactionRowView: View {
    var transaction: TransactionModel
    
    var body: some View {
        HStack {
            Text(transaction.title)
            Spacer()
            
            Text(transaction.formattedAmount)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(ColorScheme.dark)
}
