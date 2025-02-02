namespace Algos2;
public class BinaryTree
{
    private Node root;

    private class Node
    {
        public int Value;
        public Node Left;
        public Node Right;

        public Node(int value)
        {
            Value = value;
            Left = null;
            Right = null;
        }
    }

    public void Insert(int value)
    {
        Node newNode = new Node(value);
        if (root == null)
        {
            root = newNode;
            return;
        }

        Node current = root;
        while (true)
        {
            if (value < current.Value)
            {
                if (current.Left == null)
                {
                    current.Left = newNode;
                    break;
                }
                current = current.Left;
            }
            else
            {
                if (current.Right == null)
                {
                    current.Right = newNode;
                    break;
                }
                current = current.Right;
            }
        }
    }

    public bool Remove(int value)
    {
        Node parent = null;
        Node current = root;

        // Find the node to remove (parent also being removed)
        while (current != null && current.Value != value)
        {
            parent = current;
            if (value < current.Value)
                current = current.Left;
            else
                current = current.Right;
        }

        if (current == null)
            return false;

        // Case 1: Node has no children
        if (current.Left == null && current.Right == null)
        {
            if (parent == null)
                root = null;
            else if (parent.Left == current)
                parent.Left = null;
            else
                parent.Right = null;
        }
        // Case 2: Node has one child
        else if (current.Left == null || current.Right == null)
        {
            Node child = current.Left ?? current.Right;
            if (parent == null)
                root = child;
            else if (parent.Left == current)
                parent.Left = child;
            else
                parent.Right = child;
        }
        // Case 3: Node has two children
        else
        {
            // Find the inorder successor (smallest in the right subtree)
            Node successorParent = current;
            Node successor = current.Right;
            while (successor.Left != null)
            {
                successorParent = successor;
                successor = successor.Left;
            }

            current.Value = successor.Value;

            // Remove the successor node
            if (successorParent.Left == successor)
                successorParent.Left = successor.Right;
            else
                successorParent.Right = successor.Right;
        }

        return true;
    }
}