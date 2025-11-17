//
//  StatCardView.swift
//  Transactions
//
//  Created by Daniyar Yegeubay on 16/11/25.
//

import SwiftUI

struct StatCardView: View {
    let value: String
    let icon: String
    
    var body: some View {
        HStack() {
            Text(value)
                .font(Font.title3)
                .padding()
            Spacer()
            Image(systemName: icon)
                .font(Font.title2)
                .padding(10)
        }
        .background(Color(.systemGray6))
        .clipShape(
            RoundedRectangle(cornerRadius: 5)
        )
    }
}

#Preview {
    StatCardView(value: "+2000", icon: "chart.line.uptrend.xyaxis")
}
