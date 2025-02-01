import matplotlib.pyplot as plt

# Dataset sizes
sizes = [100, 500, 1000, 5000]

# Execution times for different algorithms (in seconds)
quicksort_times = [0.0009329, 0.0075299, 0.0195479, 0.248651]
mergesort_times = [0.0013409, 0.0090320, 0.0198169, 0.123548]
radixsort_times = [0.0040969, 0.0250009, 0.0511040, 0.218919]

# Create the plot
plt.figure(figsize=(10, 6))
plt.plot(sizes, quicksort_times, marker='o', linestyle='-', label='QuickSort')
plt.plot(sizes, mergesort_times, marker='s', linestyle='-', label='MergeSort')
plt.plot(sizes, radixsort_times, marker='^', linestyle='-', label='RadixSort')

# Labels and Title
plt.xlabel("Dataset Size")
plt.ylabel("Execution Time (seconds)")
plt.title("Sorting Algorithm Performance Comparison")
plt.legend()
plt.grid()

# Show the plot
plt.show()

