using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Algos2;

class Program
{
    static void Main(string[] args)
    {
        int originalN = 1000000;
        int m = (int)Math.Log(originalN + 1, 2);
        int adjustedN = (int)Math.Pow(2, m) - 1;
        Console.WriteLine($"Adjusted N to {adjustedN} to form a perfect binary tree.");

        List<int> originalOrder = GenerateRandomNumbers(adjustedN);
        List<int> sortedOriginal = new List<int>(originalOrder);
        sortedOriginal.Sort();
        List<int> bestCaseOrder = GenerateBestCaseOrder(sortedOriginal);

        // Warm-up phases
        WarmUp(originalOrder, bestCaseOrder);

        // Timing insertions and removals
        BinaryTree treeA = TimeInsertion(originalOrder, "a) Insertion: Original random order");
        TimeRemoval(treeA, originalOrder, "a) Removal: Original random order");

        BinaryTree treeB = TimeInsertion(bestCaseOrder, "b) Insertion: Best-case order");
        // Removal for best-case order not required per problem statement (not sure though lol)

        SortedSet<int> setC = TimeSortedSetInsertion(originalOrder, "c) Insertion: Library SortedSet");
        TimeSortedSetRemoval(setC, originalOrder, "c) Removal: Library SortedSet");
    }

    static List<int> GenerateRandomNumbers(int count)
    {
        List<int> numbers = Enumerable.Range(0, count).ToList();
        Random rng = new Random();
        for (int i = numbers.Count - 1; i > 0; i--)
        {
            int j = rng.Next(i + 1);
            int temp = numbers[i];
            numbers[i] = numbers[j];
            numbers[j] = temp;
        }
        return numbers;
    }

    static List<int> GenerateBestCaseOrder(List<int> sortedList)
    {
        List<int> result = new List<int>();
        if (sortedList.Count == 0)
            return result;

        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        queue.Enqueue(Tuple.Create(0, sortedList.Count - 1));

        while (queue.Count > 0)
        {
            var current = queue.Dequeue();
            int start = current.Item1;
            int end = current.Item2;
            int mid = (start + end) / 2;
            result.Add(sortedList[mid]);

            if (start <= mid - 1)
                queue.Enqueue(Tuple.Create(start, mid - 1));
            if (mid + 1 <= end)
                queue.Enqueue(Tuple.Create(mid + 1, end));
        }

        return result;
    }

    static void WarmUp(List<int> originalOrder, List<int> bestCaseOrder)
    {
        BinaryTree warmupTreeA = new BinaryTree();
        foreach (int num in originalOrder.Take(10)) warmupTreeA.Insert(num);

        BinaryTree warmupTreeB = new BinaryTree();
        foreach (int num in bestCaseOrder.Take(10)) warmupTreeB.Insert(num);

        SortedSet<int> warmupTreeC = new SortedSet<int>();
        foreach (int num in originalOrder.Take(10)) warmupTreeC.Add(num);
    }

    static BinaryTree TimeInsertion(List<int> elements, string label)
    {
        BinaryTree tree = new BinaryTree();
        Stopwatch stopwatch = Stopwatch.StartNew();
        foreach (int num in elements)
        {
            tree.Insert(num);
        }
        stopwatch.Stop();
        Console.WriteLine($"{label}: {stopwatch.ElapsedMilliseconds} ms");
        return tree;
    }

    static void TimeRemoval(BinaryTree tree, List<int> elements, string label)
    {
        Stopwatch stopwatch = Stopwatch.StartNew();
        foreach (int num in elements)
        {
            tree.Remove(num);
        }
        stopwatch.Stop();
        Console.WriteLine($"{label}: {stopwatch.ElapsedMilliseconds} ms");
    }

    static SortedSet<int> TimeSortedSetInsertion(List<int> elements, string label)
    {
        SortedSet<int> set = new SortedSet<int>();
        Stopwatch stopwatch = Stopwatch.StartNew();
        foreach (int num in elements)
        {
            set.Add(num);
        }
        stopwatch.Stop();
        Console.WriteLine($"{label}: {stopwatch.ElapsedMilliseconds} ms");
        return set;
    }

    static void TimeSortedSetRemoval(SortedSet<int> set, List<int> elements, string label)
    {
        Stopwatch stopwatch = Stopwatch.StartNew();
        foreach (int num in elements)
        {
            set.Remove(num);
        }
        stopwatch.Stop();
        Console.WriteLine($"{label}: {stopwatch.ElapsedMilliseconds} ms");
    }
}