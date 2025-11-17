//
//  TransactionsListView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 05/11/25.
//

import SwiftUI

struct TransactionsListView: View {
    var viewModel: TransactionViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.sortedTransactions) { transaction in
                TransactionRowView(transaction: transaction)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(ColorScheme.dark)
}
