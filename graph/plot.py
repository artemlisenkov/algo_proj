import matplotlib.pyplot as plt

# --------------------------------------------------------------------------------
# 1) RANDOM ARRAYS DATA
# --------------------------------------------------------------------------------
random_sizes = [5, 15, 30, 50, 500, 5000]

bubble_random   = [0.000008, 0.000036, 0.000143, 0.000376, 0.035861, 3.412207]
insertion_random= [0.000002, 0.000011, 0.000036, 0.000082, 0.006835, 0.702975]
merge_random    = [0.000012, 0.000024, 0.000051, 0.000091, 0.000862, 0.009466]
quick_random    = [0.000003, 0.000020, 0.000049, 0.000073, 0.001547, 0.019992]

plt.figure(figsize=(8, 5))
plt.plot(random_sizes, bubble_random,   marker='o', label='Bubble Sort')
plt.plot(random_sizes, insertion_random,marker='s', label='Insertion Sort')
plt.plot(random_sizes, merge_random,    marker='^', label='Merge Sort')
plt.plot(random_sizes, quick_random,    marker='d', label='Quick Sort')

plt.xlabel('Array Size')
plt.ylabel('Average Time (seconds)')
plt.title('Sorting Performance - Random Arrays')
plt.xscale('log')
plt.yscale('log')

# Simpler grid (major ticks only)
plt.grid(True, which='major', linestyle='-', linewidth=0.5, alpha=0.7)
plt.minorticks_off()

plt.legend()
plt.tight_layout()
plt.show()

# --------------------------------------------------------------------------------
# 2) PRE-SORTED ARRAYS DATA
# --------------------------------------------------------------------------------
sorted_sizes = [5, 15, 30, 50, 500, 5000]

bubble_sorted   = [0.000006, 0.000032, 0.000109, 0.000283, 0.027329, 2.711896]
insertion_sorted= [0.000002, 0.000003, 0.000008, 0.000014, 0.000115, 0.001103]
merge_sorted    = [0.000007, 0.000023, 0.000044, 0.000074, 0.000769, 0.008300]
quick_sorted    = [0.000003, 0.000028, 0.000102, 0.000283, 0.021523, 0.566544]

plt.figure(figsize=(8, 5))
plt.plot(sorted_sizes, bubble_sorted,   marker='o', label='Bubble Sort')
plt.plot(sorted_sizes, insertion_sorted,marker='s', label='Insertion Sort')
plt.plot(sorted_sizes, merge_sorted,    marker='^', label='Merge Sort')
plt.plot(sorted_sizes, quick_sorted,    marker='d', label='Quick Sort')

plt.xlabel('Array Size')
plt.ylabel('Average Time (seconds)')
plt.title('Sorting Performance - Pre-Sorted Arrays')
plt.xscale('log')
plt.yscale('log')

plt.grid(True, which='major', linestyle='-', linewidth=0.5, alpha=0.7)
plt.minorticks_off()

plt.legend()
plt.tight_layout()
plt.show()

# --------------------------------------------------------------------------------
# 3) REVERSE-SORTED ARRAYS DATA
# --------------------------------------------------------------------------------
reverse_sizes = [5, 15, 30, 50, 500, 5000]

bubble_reverse   = [0.000007, 0.000049, 0.000152, 0.000410, 0.039979, 4.021990]
insertion_reverse= [0.000003, 0.000016, 0.000060, 0.000154, 0.014040, 1.405983]
merge_reverse    = [0.000007, 0.000027, 0.000050, 0.000077, 0.000774, 0.008225]
quick_reverse    = [0.000004, 0.000029, 0.000108, 0.000282, 0.025602, 1.079515]

plt.figure(figsize=(8, 5))
plt.plot(reverse_sizes, bubble_reverse,   marker='o', label='Bubble Sort')
plt.plot(reverse_sizes, insertion_reverse,marker='s', label='Insertion Sort')
plt.plot(reverse_sizes, merge_reverse,    marker='^', label='Merge Sort')
plt.plot(reverse_sizes, quick_reverse,    marker='d', label='Quick Sort')

plt.xlabel('Array Size')
plt.ylabel('Average Time (seconds)')
plt.title('Sorting Performance - Reverse-Sorted Arrays')
plt.xscale('log')
plt.yscale('log')

plt.grid(True, which='major', linestyle='-', linewidth=0.5, alpha=0.7)
plt.minorticks_off()

plt.legend()
plt.tight_layout()
plt.show()

