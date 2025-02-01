import Foundation

// Set your hardcoded path to the directory containing CSV files.
// Example: "/Users/yourusername/Documents/CSVFiles"
let hardcodedPath = "./arrays"

// MARK: - Sorting Algorithms

func bubbleSort(_ array: inout [Int]) {
    for i in 0..<array.count {
        for j in 0..<array.count - i - 1 {
            if array[j] > array[j + 1] {
                array.swapAt(j, j + 1)
            }
        }
    }
}

func insertionSort(_ array: inout [Int]) {
    for i in 1..<array.count {
        var j = i
        while j > 0 && array[j] < array[j - 1] {
            array.swapAt(j, j - 1)
            j -= 1
        }
    }
}

func mergeSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else { return array }
    
    let mid = array.count / 2
    let left = mergeSort(Array(array[..<mid]))
    let right = mergeSort(Array(array[mid...]))
    
    return merge(left, right)
}

func merge(_ left: [Int], _ right: [Int]) -> [Int] {
    var result: [Int] = []
    var i = 0, j = 0
    
    while i < left.count && j < right.count {
        if left[i] < right[j] {
            result.append(left[i])
            i += 1
        } else {
            result.append(right[j])
            j += 1
        }
    }
    
    result.append(contentsOf: left[i...])
    result.append(contentsOf: right[j...])
    
    return result
}

func quickSort(_ array: inout [Int], low: Int, high: Int) {
    if low < high {
        let pivotIndex = partition(&array, low: low, high: high)
        quickSort(&array, low: low, high: pivotIndex - 1)
        quickSort(&array, low: pivotIndex + 1, high: high)
    }
}

func partition(_ array: inout [Int], low: Int, high: Int) -> Int {
    let pivot = array[high]
    var i = low
    
    for j in low..<high {
        if array[j] < pivot {
            array.swapAt(i, j)
            i += 1
        }
    }
    
    array.swapAt(i, high)
    return i
}

// MARK: - Helper Extension for Time Formatting

extension Double {
    func formatted() -> String {
        return String(format: "%.6f", self)
    }
}

// MARK: - CSV Loading

/// Loads arrays from a CSV file using a hardcoded path.
/// Each non-empty line in the CSV is considered an array, with elements separated by commas.
func loadArraysFromCSV(fileName: String) -> [[Int]] {
    let fileURL = URL(fileURLWithPath: hardcodedPath).appendingPathComponent(fileName + ".csv")
    
    guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        print("Error reading file: \(fileURL.path)")
        return []
    }
    
    let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
    var arrays: [[Int]] = []
    
    for line in lines {
        let numbers = line
            .components(separatedBy: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
        arrays.append(numbers)
    }
    
    return arrays
}

// MARK: - Sorting Test with Averaging

/// Tests sorting algorithms on arrays loaded from a CSV file by running each sort five times and computing the average time.
/// - Parameters:
///   - fileName: Name of the CSV file (without extension).
///   - categoryName: Category label for the arrays (e.g., "Random").
///   - expectedSizes: Optional expected sizes for each array for validation.
func testSortFromCSV(fileName: String, categoryName: String, expectedSizes: [Int]? = nil) {
    let arrays = loadArraysFromCSV(fileName: fileName)
    print("\n--- \(categoryName) Arrays from \(fileName).csv ---")
    
    // Number of iterations to average
    let iterations = 5
    
    for (index, originalArray) in arrays.enumerated() {
        if let expectedSizes = expectedSizes, index < expectedSizes.count {
            if originalArray.count != expectedSizes[index] {
                print("Warning: Expected \(expectedSizes[index]) elements, got \(originalArray.count).")
            }
        }
        
        print("\nArray Size: \(originalArray.count)")
        
        // Bubble Sort Average Time
        var bubbleTotalTime: Double = 0
        for _ in 1...iterations {
            var arrayCopy = originalArray
            let start = CFAbsoluteTimeGetCurrent()
            bubbleSort(&arrayCopy)
            let end = CFAbsoluteTimeGetCurrent()
            bubbleTotalTime += (end - start)
        }
        let bubbleAvg = bubbleTotalTime / Double(iterations)
        print("Bubble Sort Average Time: \(bubbleAvg.formatted()) seconds")
        
        // Insertion Sort Average Time
        var insertionTotalTime: Double = 0
        for _ in 1...iterations {
            var arrayCopy = originalArray
            let start = CFAbsoluteTimeGetCurrent()
            insertionSort(&arrayCopy)
            let end = CFAbsoluteTimeGetCurrent()
            insertionTotalTime += (end - start)
        }
        let insertionAvg = insertionTotalTime / Double(iterations)
        print("Insertion Sort Average Time: \(insertionAvg.formatted()) seconds")
        
        // Merge Sort Average Time
        var mergeTotalTime: Double = 0
        for _ in 1...iterations {
            let start = CFAbsoluteTimeGetCurrent()
            _ = mergeSort(originalArray)
            let end = CFAbsoluteTimeGetCurrent()
            mergeTotalTime += (end - start)
        }
        let mergeAvg = mergeTotalTime / Double(iterations)
        print("Merge Sort Average Time: \(mergeAvg.formatted()) seconds")
        
        // Quick Sort Average Time
        var quickTotalTime: Double = 0
        for _ in 1...iterations {
            var arrayCopy = originalArray
            let start = CFAbsoluteTimeGetCurrent()
            quickSort(&arrayCopy, low: 0, high: arrayCopy.count - 1)
            let end = CFAbsoluteTimeGetCurrent()
            quickTotalTime += (end - start)
        }
        let quickAvg = quickTotalTime / Double(iterations)
        print("Quick Sort Average Time: \(quickAvg.formatted()) seconds")
    }
}

// MARK: - Running Tests

// Optional: Define expected sizes for each array
let expectedSizes = [5, 15, 30, 50, 500, 5000]

// Run tests for each CSV file. Ensure the CSV files (e.g., random.csv, sorted.csv, reverseSorted.csv) exist in the directory specified by hardcodedPath.
testSortFromCSV(fileName: "random_arrays", categoryName: "Random", expectedSizes: expectedSizes)
testSortFromCSV(fileName: "sorted_arrays", categoryName: "Sorted", expectedSizes: expectedSizes)
testSortFromCSV(fileName: "reverse_sorted_arrays", categoryName: "Reverse Sorted", expectedSizes: expectedSizes)

