// Bubble Sort Implementation
func bubbleSort(_ array: inout [Int]) {
    for i in 0..<array.count {
        for j in 0..<array.count - i - 1 {
            if array[j] > array[j + 1] {
                array.swapAt(j, j + 1)
            }
        }
    }
}

// Insertion Sort Implementation
func insertionSort(_ array: inout [Int]) {
    for i in 1..<array.count {
        var j = i
        while j > 0 && array[j] < array[j - 1] {
            array.swapAt(j, j - 1)
            j -= 1
        }
    }
}

// Merge Sort Implementation
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

// Quick Sort Implementation
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


import Foundation

extension Double {
    func formatted() -> String {
        return String(format: "%.6f", self)
    }
}

func testSort(arraySizes: [Int]) {
    print("\n--- Random Arrays ---")
    for size in arraySizes {
        let randomArray = (0..<size).map { _ in Int.random(in: 0...1000) }

        print("\nArray Size: \(size)")

        // Bubble Sort
        var bubbleSortRandomArray = randomArray
        let bubbleStart = CFAbsoluteTimeGetCurrent()
        bubbleSort(&bubbleSortRandomArray)
        let bubbleEnd = CFAbsoluteTimeGetCurrent()
        print("Bubble Sort: \((bubbleEnd - bubbleStart).formatted()) seconds")

        // Insertion Sort
        var insertionSortRandomArray = randomArray
        let insertionStart = CFAbsoluteTimeGetCurrent()
        insertionSort(&insertionSortRandomArray)
        let insertionEnd = CFAbsoluteTimeGetCurrent()
        print("Insertion Sort: \((insertionEnd - insertionStart).formatted()) seconds")

        // Merge Sort
        let mergeSortRandomStart = CFAbsoluteTimeGetCurrent()
        let _ = mergeSort(randomArray)
        let mergeEnd = CFAbsoluteTimeGetCurrent()
        print("Merge Sort: \((mergeEnd - mergeSortRandomStart).formatted()) seconds")

        // Quick Sort
        var quickSortRandomArray = randomArray
        let quickStart = CFAbsoluteTimeGetCurrent()
        quickSort(&quickSortRandomArray, low: 0, high: quickSortRandomArray.count - 1)
        let quickEnd = CFAbsoluteTimeGetCurrent()
        print("Quick Sort: \((quickEnd - quickStart).formatted()) seconds")
    }

    // Bonus Info: Pre-Sorted Array
    print("\n--- Bonus Info: Pre-Sorted Arrays ---")
    for size in arraySizes {
        let sortedArray = (0..<size).map { $0 }

        print("\nArray Size: \(size)")

        // Bubble Sort
        var bubbleSortSortedArray = sortedArray
        let bubbleStart = CFAbsoluteTimeGetCurrent()
        bubbleSort(&bubbleSortSortedArray)
        let bubbleEnd = CFAbsoluteTimeGetCurrent()
        print("Bubble Sort: \((bubbleEnd - bubbleStart).formatted()) seconds")

        // Insertion Sort
        var insertionSortSortedArray = sortedArray
        let insertionStart = CFAbsoluteTimeGetCurrent()
        insertionSort(&insertionSortSortedArray)
        let insertionEnd = CFAbsoluteTimeGetCurrent()
        print("Insertion Sort: \((insertionEnd - insertionStart).formatted()) seconds")

        // Merge Sort
        let mergeStart = CFAbsoluteTimeGetCurrent()
        let _ = mergeSort(sortedArray)
        let mergeEnd = CFAbsoluteTimeGetCurrent()
        print("Merge Sort: \((mergeEnd - mergeStart).formatted()) seconds")

        // Quick Sort
        var quickSortSortedArray = sortedArray
        let quickStart = CFAbsoluteTimeGetCurrent()
        quickSort(&quickSortSortedArray, low: 0, high: quickSortSortedArray.count - 1)
        let quickEnd = CFAbsoluteTimeGetCurrent()
        print("Quick Sort: \((quickEnd - quickStart).formatted()) seconds")
    }

    // Bonus Info: Reverse-Sorted Array
    print("\n--- Bonus Info: Reverse-Sorted Arrays ---")
    for size in arraySizes {
        let reverseSortedArray = (0..<size).map { size - $0 - 1 }

        print("\nArray Size: \(size)")

        // Bubble Sort
        var bubbleSortRevSortedArray = reverseSortedArray
        let bubbleStart = CFAbsoluteTimeGetCurrent()
        bubbleSort(&bubbleSortRevSortedArray)
        let bubbleEnd = CFAbsoluteTimeGetCurrent()
        print("Bubble Sort: \((bubbleEnd - bubbleStart).formatted()) seconds")

        // Insertion Sort
        var insertionSortRevSortedArray = reverseSortedArray
        let insertionStart = CFAbsoluteTimeGetCurrent()
        insertionSort(&insertionSortRevSortedArray)
        let insertionEnd = CFAbsoluteTimeGetCurrent()
        print("Insertion Sort: \((insertionEnd - insertionStart).formatted()) seconds")

        // Merge Sort
        let mergeStart = CFAbsoluteTimeGetCurrent()
        let _ = mergeSort(reverseSortedArray)
        let mergeEnd = CFAbsoluteTimeGetCurrent()
        print("Merge Sort: \((mergeEnd - mergeStart).formatted()) seconds")

        // Quick Sort
        var quickSortRevSortedArray = reverseSortedArray
        let quickStart = CFAbsoluteTimeGetCurrent()
        quickSort(&quickSortRevSortedArray, low: 0, high: quickSortRevSortedArray.count - 1)
        let quickEnd = CFAbsoluteTimeGetCurrent()
        print("Quick Sort: \((quickEnd - quickStart).formatted()) seconds")
    }
}
// Example Test
let arraySizes = [5, 15, 30, 50, 500, 5000]
testSort(arraySizes: arraySizes)

