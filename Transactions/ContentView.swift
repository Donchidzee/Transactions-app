//
//  ContentView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 02/11/25.
//

import SwiftUI
import Vision

struct ContentView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house", value: 0) {
                DashboardView()
            }
            
            Tab("Transactions", systemImage: "dollarsign.square", value: 1) {
                Color("TransactionsBackground")
                    .ignoresSafeArea()
            }
            
            Tab("Statistics", systemImage: "chart.pie", value: 2) {
                Color("TransactionsBackground")
                    .ignoresSafeArea()
            }
            
            Tab("Settings", systemImage: "gearshape", value: 3) {
                Color("TransactionsBackground")
                    .ignoresSafeArea()
            }
        }
        .tint(.accent)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
