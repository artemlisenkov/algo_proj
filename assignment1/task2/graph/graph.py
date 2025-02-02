import matplotlib.pyplot as plt

# append data (x = num of el, y = time in sec)
append_sizes = [10_000, 50_000, 100_000, 500_000, 1_000_000]

append_my = [
    0.006097674369812012,    # 10k
    0.015121976534525553,    # 50k
    0.02396229902903239,     # 100k
    0.11924564838409424,     # 500k
    0.24101599057515463      # 1m
]
append_swift = [
    0.004137992858886719,    # 10k
    0.011156320571899414,    # 50k
    0.02192068099975586,     # 100k
    0.11875434716542561,     # 500k
    0.22169435024261475      # 1m
]

# remove data
remove_sizes = [10_000, 50_000, 100_000, 500_000, 1_000_000]
remove_my = [
    0.0032349824905395508,   # 10k
    0.030518054962158203,    # 50k
    0.09468503793080647,     # 100k
    1.8377256790796916,      # 500k
    7.109314680099487        # 1m
]
remove_swift = [
    0.002897024154663086,    # 10k
    0.02929798762003581,     # 50k
    0.09225034713745117,     # 100k
    1.8318140109380086,      # 500k
    7.032287319501241        # 1m
]

# === Create two subplots side by side (or change layout to your preference) ===
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 5))

# plot 1: append performance
axes[0].plot(append_sizes, append_my, marker='o', label='MyDynamicArray')
axes[0].plot(append_sizes, append_swift, marker='o', label='Swift Array')
axes[0].set_title('Append Performance')
axes[0].set_xlabel('Number of Elements')
axes[0].set_ylabel('Time (seconds)')
axes[0].grid(True)
axes[0].legend()

# plot 2: remove performance
axes[1].plot(remove_sizes, remove_my, marker='o', label='MyDynamicArray')
axes[1].plot(remove_sizes, remove_swift, marker='o', label='Swift Array')
axes[1].set_title('Remove Performance')
axes[1].set_xlabel('Number of Elements')
axes[1].set_ylabel('Time (seconds)')
axes[1].grid(True)
axes[1].legend()

plt.tight_layout()
plt.show()

