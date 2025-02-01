import Foundation

// set hardcoded path to directory with CSV files
let hardcodedPath = "arrays/"

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

// load arrays (csv files) using hardcoded path
// all files arrays that non-empty - considered as arrays. Arrays by itself in csv files are separated by 
// newlines and elements init - by commas
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

// testin algorithms. run each 5 times and output avg time
/// - params:
///   - fileName: name of the CSV file (without extension).
///   - categoryName: category label for the arrays (e.g. "Random").
///   - expectedSizes: optional expected sizes for each array for validation.
func testSortFromCSV(fileName: String, categoryName: String, expectedSizes: [Int]? = nil) {
    let arrays = loadArraysFromCSV(fileName: fileName)
    print("\n--- \(categoryName) Arrays from \(fileName).csv ---")
    
    // num of runnings (for avg)
    let iterations = 5
    
    for (index, originalArray) in arrays.enumerated() {
        if let expectedSizes = expectedSizes, index < expectedSizes.count {
            if originalArray.count != expectedSizes[index] {
                print("Warning: Expected \(expectedSizes[index]) elements, got \(originalArray.count).")
            }
        }
        
        print("\nArray Size: \(originalArray.count)")
        
        // bubble sort (avg of 5)
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
        
        // insertion sort (avg of 5)
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
        
        // merge sort (avg of 5)
        var mergeTotalTime: Double = 0
        for _ in 1...iterations {
            let start = CFAbsoluteTimeGetCurrent()
            _ = mergeSort(originalArray)
            let end = CFAbsoluteTimeGetCurrent()
            mergeTotalTime += (end - start)
        }
        let mergeAvg = mergeTotalTime / Double(iterations)
        print("Merge Sort Average Time: \(mergeAvg.formatted()) seconds")
        
        // quicksort (avg of 5)
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

// expected sizes of arrays (optional)
let expectedSizes = [5, 15, 30, 50, 500, 5000]

// run test on each csv file (we have to be sure that file of "fileName" exists in hardcoded path (without csv extension))
testSortFromCSV(fileName: "random_arrays", categoryName: "Random", expectedSizes: expectedSizes)
testSortFromCSV(fileName: "sorted_arrays", categoryName: "Sorted", expectedSizes: expectedSizes)
testSortFromCSV(fileName: "reverse_sorted_arrays", categoryName: "Reverse Sorted", expectedSizes: expectedSizes)

