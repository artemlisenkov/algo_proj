import Foundation // or import Darwin for memmove

class MyDynamicArray {
    private var capacity: Int
    private var size: Int
    private var buffer: UnsafeMutablePointer<Int>!

    init(_ initialCapacity: Int = 2) {
        capacity = max(1, initialCapacity)
        size = 0
        buffer = .allocate(capacity: capacity)
        buffer.initialize(repeating: 0, count: capacity)
    }

    deinit {
        buffer.deinitialize(count: capacity)
        buffer.deallocate()
    }

    var count: Int { size }

    subscript(_ i: Int) -> Int {
        get {
            precondition(i >= 0 && i < size)
            return buffer[i]
        }
        set {
            precondition(i >= 0 && i < size)
            buffer[i] = newValue
        }
    }

    func append(_ x: Int) {
        if size == capacity { grow() }
        buffer[size] = x
        size += 1
    }

    private func grow() {
        let newCap = capacity * 2
        let newBuf = UnsafeMutablePointer<Int>.allocate(capacity: newCap)
        newBuf.initialize(from: buffer, count: size)
        buffer.deinitialize(count: capacity)
        buffer.deallocate()
        buffer = newBuf
        capacity = newCap
    }

    // Optimized remove using memmove.
    // Still O(n) in the worst case, but much faster than a manual loop.
    func remove(at i: Int) {
        precondition(i >= 0 && i < size)
        if i < size - 1 {
            let dst = buffer + i
            let src = buffer + i + 1
            let bytesToMove = (size - i - 1) * MemoryLayout<Int>.stride
            memmove(dst, src, bytesToMove)
        }
        size -= 1
    }

    // If you need to remove multiple consecutive elements at once,
    // do a single memmove.
    func removeRange(start: Int, length: Int) {
        precondition(start >= 0 && start + length <= size)
        if start + length < size {
            let dst = buffer + start
            let src = buffer + start + length
            let bytesToMove = (size - (start + length)) * MemoryLayout<Int>.stride
            memmove(dst, src, bytesToMove)
        }
        size -= length
    }

    func clear() {
        size = 0
    }
}

// MARK: - Measurement Helpers

/// Helper to measure the average time of multiple runs of a closure.
func measure(label: String, runs: Int, block: () -> Void) -> Double {
    var times = [Double]()
    for _ in 1...runs {
        let start = CFAbsoluteTimeGetCurrent()
        block()
        let end = CFAbsoluteTimeGetCurrent()
        times.append(end - start)
    }
    let avg = times.reduce(0, +) / Double(runs)
    print("\(label) average time: \(avg) seconds\n")
    return avg
}

/// Perform a test of appending "count" elements to MyDynamicArray.
func testMyDynamicArrayAppend(count: Int) {
    let myArr = MyDynamicArray()
    for i in 0..<count {
        myArr.append(i)
    }
}

/// Perform a test of appending "count" elements to Swift [Int].
func testSwiftArrayAppend(count: Int) {
    var swiftArr = [Int]()
    swiftArr.reserveCapacity(count) //this one is optional
    for i in 0..<count {
        swiftArr.append(i)
    }
}

/// Perform a test of removing "removalCount" elements from MyDynamicArray.
func testMyDynamicArrayRemove(count: Int, removalCount: Int) {
    let myArr = MyDynamicArray()
    // First, fill it up
    for i in 0..<count {
        myArr.append(i)
    }
    // Remove from random positions (or from the front, etc.)
    for _ in 0..<removalCount {
        let removeIndex = myArr.count / 2  // e.g., remove from the middle
        myArr.remove(at: removeIndex)
    }
}

/// Perform a test of removing "removalCount" elements from Swift Array.
func testSwiftArrayRemove(count: Int, removalCount: Int) {
    var swiftArr = [Int]()
    swiftArr.reserveCapacity(count)
    // First, fill it up
    for i in 0..<count {
        swiftArr.append(i)
    }
    // Remove from random positions (or from the front, etc.)
    for _ in 0..<removalCount {
        let removeIndex = swiftArr.count / 2  // e.g., remove from the middle
        swiftArr.remove(at: removeIndex)
    }
}

// MARK: - Full Test

func runPerformanceTests() {
    let testRuns = 3
    let sizes = [10_000, 50_000, 100_000, 500_000, 1_000_000]

    for size in sizes {
        print("=== Testing append with \(size) elements ===")
        measure(label: "MyDynamicArray append \(size)", runs: testRuns) {
            testMyDynamicArrayAppend(count: size)
        }
        measure(label: "Swift Array append \(size)", runs: testRuns) {
            testSwiftArrayAppend(count: size)
        }
    }

    // Remove 10%.
    for size in sizes {
        let removalCount = size / 10
        print("=== Testing remove with \(size) elements (removing \(removalCount)) ===")

        measure(label: "MyDynamicArray remove from \(size)", runs: testRuns) {
            testMyDynamicArrayRemove(count: size, removalCount: removalCount)
        }
        measure(label: "Swift Array remove from \(size)", runs: testRuns) {
            testSwiftArrayRemove(count: size, removalCount: removalCount)
        }
    }
}

// run test
runPerformanceTests()

