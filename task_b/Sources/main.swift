import Foundation

// MARK: - Read CSV File with Full Path
func readCSV(filePath: String) -> [[String]] {
    let fileURL = URL(fileURLWithPath: filePath)
    guard let content = try? String(contentsOf: fileURL) else { return [] }
    let rows = content.components(separatedBy: "\n").map { $0.components(separatedBy: ",") }
    return rows.filter { !$0.isEmpty && $0.count > 1 } // Ensure valid rows
}

// MARK: - Convert Expiry Date to Sortable Key
func expiryKey(_ expiryDate: String) -> Int {
    let components = expiryDate.split(separator: "/")
    if components.count == 2, let month = Int(components[0]), let year = Int(components[1]) {
        return year * 100 + month // Sorting by YYYYMM
    }
    return 0
}

// MARK: - Sort Data by Expiry Date and PIN
func sortByExpiryAndPin(_ data: [[String]]) -> [[String]] {
    return data.sorted { 
        let key1 = expiryKey($0[1])
        let key2 = expiryKey($1[1])
        let pin1 = Int($0[3]) ?? 0
        let pin2 = Int($1[3]) ?? 0
        return key1 != key2 ? key1 < key2 : pin1 < pin2
    }
}

// MARK: - Merge Sorted Data
func mergeData(first12: [[String]], last4: [[String]]) -> [[String]] {
    print("First part size: \(first12.count), Second part size: \(last4.count)")
    guard first12.count == last4.count else {
        print("Error: Mismatch in sizes - cannot merge.")
        return []
    }
    
    var mergedData = [[String]]()
    for (index, row) in first12.enumerated() {
        let fullCardNumber = row[0].dropLast(4) + last4[index][0].suffix(4)
        var mergedRow = [String(fullCardNumber)]
        mergedRow.append(contentsOf: last4[index][1...])
        mergedData.append(mergedRow)
    }
    
    // Sort the merged data by Expiry Date and PIN
    return sortByExpiryAndPin(mergedData)
}

// MARK: - Write CSV to File
func writeCSV(filePath: String, data: [[String]]) {
    let fileURL = URL(fileURLWithPath: filePath, isDirectory: false).standardized
    
    let csvString = data.map { $0.joined(separator: ",") }.joined(separator: "\n")
    do {
        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        print("Successfully saved CSV at: \(fileURL.path)")
    } catch {
        print("Error writing CSV file: \(error)")
    }
}

// MARK: - Execution
let start = CFAbsoluteTimeGetCurrent()

var firstPart = readCSV(filePath: "/Users/artemlisenkov/algo_proj/task_b/carddumps/sorted.csv")
var secondPart = readCSV(filePath: "/Users/artemlisenkov/algo_proj/task_b/carddumps/shuffled.csv")

let sortStart = CFAbsoluteTimeGetCurrent()
let sortedSecondPart = sortByExpiryAndPin(secondPart)
let sortEnd = CFAbsoluteTimeGetCurrent()

let mergeStart = CFAbsoluteTimeGetCurrent()
var mergedData = mergeData(first12: firstPart, last4: sortedSecondPart)
let mergeEnd = CFAbsoluteTimeGetCurrent()

if !mergedData.isEmpty {
    let outputFilePath = "/Users/artemlisenkov/algo_proj/task_b/carddumps/final.csv"
    writeCSV(filePath: outputFilePath, data: mergedData)
    print("Merged file saved at: \(outputFilePath)")
} else {
    print("Merge failed. No output file created.")
}

let totalEnd = CFAbsoluteTimeGetCurrent()

// MARK: - Print Execution Times
print("Sorting Time: \(sortEnd - sortStart) seconds")
print("Merging Time: \(mergeEnd - mergeStart) seconds")
print("Total Execution Time: \(totalEnd - start) seconds")

