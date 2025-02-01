import Foundation

// MARK: - Generate Synthetic Data
/// Generates a dataset with random expiry dates, PINs, and last 4 card digits.
/// - Parameter size: Number of records to generate.
/// - Returns: A shuffled dataset of credit card records.
func generateSyntheticData(size: Int) -> [[String]] {
    let months = (1...12).map { String(format: "%02d", $0) }
    let years = (24...30).map { String($0) }
    var dataset = [[String]]()
    
    for _ in 0..<size {
        let expiryDate = "\(months.randomElement()!)/\(years.randomElement()!)"
        let pin = String(format: "%04d", Int.random(in: 1000...9999))
        let lastFourDigits = String(format: "%04d", Int.random(in: 1000...9999))
        dataset.append([lastFourDigits, expiryDate, pin])
    }
    return dataset.shuffled()
}

// MARK: - Sorting Utilities
/// Converts an expiry date string to a numerical key for sorting.
/// - Parameter expiryDate: The expiry date in MM/YY format.
/// - Returns: A sortable integer representation (YYYYMM).
func expiryKey(_ expiryDate: String) -> Int {
    let components = expiryDate.split(separator: "/")
    if components.count == 2, let month = Int(components[0]), let year = Int(components[1]) {
        return year * 100 + month
    }
    return 0
}

// MARK: - Sorting Algorithms

/// QuickSort implementation
func quickSort(_ array: inout [[String]], low: Int, high: Int) {
    if low < high {
        let pivot = partition(&array, low: low, high: high)
        quickSort(&array, low: low, high: pivot - 1)
        quickSort(&array, low: pivot + 1, high: high)
    }
}

/// Partition function for QuickSort
func partition(_ array: inout [[String]], low: Int, high: Int) -> Int {
    let pivot = expiryKey(array[high][1])
    var i = low
    for j in low..<high {
        if expiryKey(array[j][1]) < pivot {
            array.swapAt(i, j)
            i += 1
        }
    }
    array.swapAt(i, high)
    return i
}

/// MergeSort implementation
func mergeSort(_ array: [[String]]) -> [[String]] {
    guard array.count > 1 else { return array }
    let mid = array.count / 2
    let left = mergeSort(Array(array[..<mid]))
    let right = mergeSort(Array(array[mid...]))
    return merge(left, right)
}

/// Merge function for MergeSort
func merge(_ left: [[String]], _ right: [[String]]) -> [[String]] {
    var sortedArray = [[String]]()
    var leftIndex = 0, rightIndex = 0
    while leftIndex < left.count && rightIndex < right.count {
        if expiryKey(left[leftIndex][1]) < expiryKey(right[rightIndex][1]) {
            sortedArray.append(left[leftIndex])
            leftIndex += 1
        } else {
            sortedArray.append(right[rightIndex])
            rightIndex += 1
        }
    }
    sortedArray.append(contentsOf: left[leftIndex...])
    sortedArray.append(contentsOf: right[rightIndex...])
    return sortedArray
}

/// RadixSort implementation
func radixSort(_ array: inout [[String]]) {
    array.sort { 
        let key1 = expiryKey($0[1])
        let key2 = expiryKey($1[1])
        let pin1 = Int($0[2]) ?? 0
        let pin2 = Int($1[2]) ?? 0
        return key1 != key2 ? key1 < key2 : pin1 < pin2
    }
}

// MARK: - Benchmarking

/// Measures execution time of a sorting algorithm.
func benchmarkSortingAlgorithm(name: String, sortingFunction: ([[String]]) -> [[String]], data: [[String]]) -> TimeInterval {
    let start = CFAbsoluteTimeGetCurrent()
    _ = sortingFunction(data)
    let end = CFAbsoluteTimeGetCurrent()
    print("\(name) took \(end - start) seconds")
    return end - start
}

/// Runs benchmarks on different sorting algorithms across dataset sizes.
func benchmarkSortingAlgorithms() {
    let sizes = [100, 500, 1000, 5000]
    
    for size in sizes {
        print("\nBenchmarking sorting algorithms for dataset size: \(size)")
        let dataset = generateSyntheticData(size: size)
        
        _ = benchmarkSortingAlgorithm(name: "QuickSort", sortingFunction: { data in
            var mutableData = data
            quickSort(&mutableData, low: 0, high: mutableData.count - 1)
            return mutableData
        }, data: dataset)
        
        _ = benchmarkSortingAlgorithm(name: "MergeSort", sortingFunction: mergeSort, data: dataset)
        
        var radixData = dataset
        let radixStart = CFAbsoluteTimeGetCurrent()
        radixSort(&radixData)
        let radixEnd = CFAbsoluteTimeGetCurrent()
        let radixTime = radixEnd - radixStart
        print("RadixSort took \(radixTime) seconds")
    }
}

// Run Benchmark
benchmarkSortingAlgorithms()
