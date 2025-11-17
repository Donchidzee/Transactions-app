import SwiftUI

@Observable
class TransactionViewModel {
    var transactions: [TransactionModel] = []
    
    init(transactions: [TransactionModel] = TransactionModel.mockData) {
        self.transactions = transactions
    }
    
    var sortedTransactions: [TransactionModel] {
        transactions.sorted { $0.date > $1.date }
    }
    
    var balance: Double {
        totalIncome - totalExpense
    }
    
    var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    func addTransaction(_ transaction: TransactionModel) {
        transactions.append(transaction)
    }
    
    func deleteTransaction(_ transaction: TransactionModel) {
        transactions.removeAll { $0.id == transaction.id }
    }
}

extension TransactionViewModel {
    var formattedBalance: String {
        return "\(balance)"
    }
    
    var formattedTotalIncome: String {
        return "+\(totalIncome)"
    }
    
    var formattedTotalExpense: String {
        return "-\(totalExpense)"
    }
}

extension TransactionViewModel {
    static var preview: TransactionViewModel {
        let vm = TransactionViewModel()
        vm.transactions = TransactionModel.mockData
        return vm
    }
}

extension TransactionViewModel {
    func parseReceipt(_ text: String) -> TransactionModel? {
        // 1. Normalize lines
        let lines = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !lines.isEmpty else { return nil }
        
        // 2. Merchant name: first line
        let title = lines.first ?? "Receipt"
        
        // 3. Keywords
        let totalKeywords = [
            "total amount",
            "total",
            "grand total",
            "amount due",
            "totale complessivo",
            "totale"
        ]
        let cashKeywords = [
            "cash",
            "contanti"
        ]
        let changeKeywords = [
            "change",
            "resto"
        ]
        let ignoreKeywords = [
            "change",
            "resto",
            "cashback"
        ]
        
        // Helper: does a line contain any of the given keywords?
        func containsKeyword(in text: String, keywords: [String]) -> Bool {
            let lower = text.lowercased()
            let compact = lower.replacingOccurrences(of: " ", with: "")
            
            return keywords.contains { kw in
                let kLower = kw.lowercased()
                let kCompact = kLower.replacingOccurrences(of: " ", with: "")
                return lower.contains(kLower) || compact.contains(kCompact)
            }
        }
        
        var foundAmount: Double?
        
        // 4. Try explicit TOTAL line (bottom → top)
        if let totalLine = lines.reversed().first(where: { line in
            containsKeyword(in: line, keywords: totalKeywords)
        }) {
            foundAmount = extractAmount(from: totalLine)
        }
        
        // 5. If no TOTAL line, try "CASH - CHANGE" pattern
        if foundAmount == nil {
            let cashLine = lines.reversed().first { containsKeyword(in: $0, keywords: cashKeywords) }
            let changeLine = lines.reversed().first { containsKeyword(in: $0, keywords: changeKeywords) }
            
            if
                let cashLine,
                let changeLine,
                let cashAmount = extractAmount(from: cashLine),
                let changeAmount = extractAmount(from: changeLine),
                cashAmount >= changeAmount
            {
                foundAmount = cashAmount - changeAmount
            }
        }
        
        // 6. Fallback: last numeric line that is NOT "CHANGE"/"RESTO"
        if foundAmount == nil {
            if let candidateLine = lines.reversed().first(where: { line in
                !containsKeyword(in: line, keywords: ignoreKeywords) &&
                extractAmount(from: line) != nil
            }) {
                foundAmount = extractAmount(from: candidateLine)
            }
        }
        
        guard let amount = foundAmount else { return nil }
        
        return TransactionModel(
            title: title,
            amount: amount,
            type: .expense,
            category: .food,
            date: Date(),
            notes: "Scanned from receipt"
        )
    }
    
    /// Extracts the last decimal number from a line (supports 95.00, 95,00, 1 234,56, etc.)
    private func extractAmount(from line: String) -> Double? {
        let pattern = #"[0-9]+(?:[.,][0-9]{2})?"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(line.startIndex..<line.endIndex, in: line)
        
        // Take the last match – on "TOTAL AMOUNT  $ 95.00" this gives 95.00
        guard let match = regex.matches(in: line, range: range).last else { return nil }
        
        let nsLine = line as NSString
        var numberString = nsLine.substring(with: match.range)
        numberString = numberString.replacingOccurrences(of: ",", with: ".")
        
        return Double(numberString)
    }
}

