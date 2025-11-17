//
//  DashboardView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 04/11/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel = TransactionViewModel()
    @State private var showTransactionsAddingOptionsMenu = false
    @State private var showTrasactionAddingModal = false
    @State private var showScanner = false
    @State private var scannedText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack() {
                    Text("Balance: \(viewModel.formattedBalance)")
                        .font(Font.title.bold())
                        .padding()
                    Spacer()
                }
                .background(Color.accent)
                .clipShape(
                    RoundedRectangle(cornerRadius: 5)
                )
                .padding(.horizontal)
                .padding(.top, 20)
                
                HStack(spacing: 10) {
                    StatCardView(value: viewModel.formattedTotalIncome, icon: "chart.line.uptrend.xyaxis")
                    StatCardView(value: viewModel.formattedTotalExpense, icon: "chart.line.downtrend.xyaxis")
                }
                .padding(.horizontal)
                
                TransactionsListView(viewModel: viewModel)
                
            }
            .navigationTitle("Dashboard")
            .background(Color("TransactionsBackgroundColor"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showTrasactionAddingModal = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                            Text("Add Manually")
                        }
                        
                        Button {
                            showScanner = true
                        } label: {
                            Image(systemName: "camera.viewfinder")
                            Text("Scan")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showTrasactionAddingModal) {
                TransactionAddingModalView(viewModel: viewModel)
                    .background(Color("TransactionsBackgroundColor"))
            }
            .sheet(isPresented: $showScanner) {
                DocumentScannerView(scannedText: $scannedText)
                    .onDisappear {
                        if !scannedText.isEmpty {
                            parseAndAdd()
                        }
                    }
            }
        }
    }
    
    func parseAndAdd() {
        if let transaction = viewModel.parseReceipt(scannedText) {
            viewModel.addTransaction(transaction)
        }
    }
}

#Preview {
    DashboardView().preferredColorScheme(.dark)
}
