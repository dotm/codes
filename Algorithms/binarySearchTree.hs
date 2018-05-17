import Test.HUnit

-- BST properties:
  -- keys must be unique
  -- left children is less than parent
  -- right children is greater than parent
data Tree a = Empty_Node | Node a (Tree a) (Tree a) deriving (Show)
instance (Eq a) => Eq (Tree a) where
  Empty_Node == Empty_Node = True
  Empty_Node == _ = False
  (Node a (Empty_Node) (Empty_Node)) == (Node b (Empty_Node) (Empty_Node)) = a == b
  (Node a left1 (Empty_Node)) == (Node b left2 (Empty_Node)) = (a == b && left1 == left2)
  (Node a (Empty_Node) right1) == (Node b (Empty_Node) right2) = (a == b && right1 == right2)
  (Node a left1 right1) == (Node b left2 right2) = ((a == b) && (left1 == left2) && (right1 == right2))
  _ == _ = False

insert_tree :: (Ord a) => a -> Tree a -> Tree a
insert_tree x Empty_Node = Node x (Empty_Node) (Empty_Node)
insert_tree x (Node a leftTree rightTree)
  | (x == a) = Node a leftTree rightTree
  | (x < a) = Node a (insert_tree x leftTree) rightTree
  | (x > a) = Node a leftTree (insert_tree x rightTree)

convertList_toTree :: (Ord a) => [a] -> Tree a
convertList_toTree [] = Empty_Node
convertList_toTree (x:y) = (insert_tree x (convertList_toTree y))

traverseTree_inOrder :: Tree a -> [a]
traverseTree_inOrder Empty_Node = []
traverseTree_inOrder (Node v Empty_Node Empty_Node) = [v]
traverseTree_inOrder (Node v leftTree rightTree) = (traverseTree_inOrder leftTree) ++ [v] ++ (traverseTree_inOrder rightTree)

{-
applyFunction_inOrder :: (a -> b) -> Tree a -> Tree b

instance Functor Tree where
  

instance Monad Tree where
  return :: a -> m a
  return x = insert_tree x Empty_Node
  -- (>>=) :: m a -> (a -> m b) -> m b
  -- >>=
-}
  
-- Unit Test for insert_tree function
insert_tree_test1_1 = TestCase (assertEqual
  "should create one node with the inserted value as key and two empty node as children"
  (Node 1 (Empty_Node) (Empty_Node))
  (insert_tree 1 Empty_Node)
  )
insert_tree_test2_1 = TestCase (assertEqual
  "should just ignore the inserted value since the keys must be unique"
  (Node 1 (Empty_Node) Empty_Node)
  (insert_tree 1 (Node 1 (Empty_Node) (Empty_Node)))
  )
insert_tree_test2_2 = TestCase (assertEqual
  "should insert a node to the left of current tree"
  (Node 2 (Node 1 Empty_Node Empty_Node) Empty_Node)
  (insert_tree 1 (Node 2 (Empty_Node) (Empty_Node)))
  )
insert_tree_test2_3 = TestCase (assertEqual
  "should insert a node to the right of current tree"
  (Node 1 Empty_Node (Node 2 Empty_Node Empty_Node))
  (insert_tree 2 (Node 1 (Empty_Node) (Empty_Node)))
  )
insert_tree_test3_1 = TestCase (assertEqual
  "should just ignore the inserted value since the keys must be unique"
  (Node 200 (Node 100 Empty_Node Empty_Node) Empty_Node)
  (insert_tree 200 (Node 200 (Node 100 (Empty_Node) (Empty_Node)) (Empty_Node)))
  )
insert_tree_test3_2 = TestCase (assertEqual
  "should insert a node to the right of left children"
  (Node 200 (Node 100 Empty_Node (Node 150 Empty_Node Empty_Node)) Empty_Node)
  (insert_tree 150 (Node 200 (Node 100 (Empty_Node) (Empty_Node)) (Empty_Node)))
  )
insert_tree_test3_3 = TestCase (assertEqual
  "should insert a node to the left of left children"
  (Node 200 (Node 100 (Node 50 Empty_Node Empty_Node) Empty_Node) Empty_Node)
  (insert_tree 50 (Node 200 (Node 100 (Empty_Node) (Empty_Node)) (Empty_Node)))
  )
insert_tree_test4_1 = TestCase (assertEqual
  "should just ignore the inserted value since the keys must be unique"
  (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node)))
  (insert_tree 200 (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node))))
  )
insert_tree_test4_2 = TestCase (assertEqual
  "should insert a node to the left of right children"
  (Node 200 Empty_Node (Node 300 (Node 250 Empty_Node Empty_Node) Empty_Node))
  (insert_tree 250 (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node))))
  )
insert_tree_test4_3 = TestCase (assertEqual
  "should insert a node to the right of right children"
  (Node 200 Empty_Node (Node 300 Empty_Node (Node 350 Empty_Node Empty_Node)))
  (insert_tree 350 (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node))))
  )
insert_tree_tests = TestList [
  TestLabel "Inserting to empty tree" insert_tree_test1_1,
  
  --tree doesn't have any duplicate key
  TestLabel "Inserting to a tree with no children, with value inserted equal to tree value" insert_tree_test2_1,
  --left children value should be less than parent value
  TestLabel "Inserting to a tree with no children, with value inserted less than tree value" insert_tree_test2_2,
  --right children value should be greater than parent value
  TestLabel "Inserting to a tree with no children, with value inserted greater than tree value" insert_tree_test2_2,
  
  TestLabel "Inserting to a tree with left children, with value inserted equal to tree value" insert_tree_test3_1,
  TestLabel "Inserting to a tree with left children, with value inserted less than tree value, but more than left children" insert_tree_test3_2,
  TestLabel "Inserting to a tree with left children, with value inserted less than tree value, and less than left children" insert_tree_test3_3,
  
  TestLabel "Inserting to a tree with right children, with value inserted equal to tree value" insert_tree_test4_1,
  TestLabel "Inserting to a tree with right children, with value inserted more than tree value, but less than right children" insert_tree_test4_2,
  TestLabel "Inserting to a tree with right children, with value inserted more than tree value, and more than right children" insert_tree_test4_3
  ]

-- Unit Test for convertList_toTree function

convertList_toTree_test1_1 = TestCase (assertEqual
  "should create a tree with one empty node"
  (Empty_Node :: Tree Int)
  (convertList_toTree ([] :: [] Int))
  )
convertList_toTree_test2_1 = TestCase (assertEqual
  "should create a tree with one parent node with 2 empty children and the supplied single argument used as the node value"
  (Node 1 (Empty_Node) (Empty_Node))
  (convertList_toTree [1])
  )
convertList_toTree_test3_1 = TestCase (assertEqual
  "should return a binary search tree with correct properties"
  (Node 2 (Node 1 Empty_Node Empty_Node) Empty_Node)
  (convertList_toTree [1,2])
  )
convertList_toTree_test3_2 = TestCase (assertEqual
  "should return a binary search tree with correct properties"
  (Node 1 Empty_Node (Node 2 Empty_Node Empty_Node))
  (convertList_toTree [2,1])
  )
convertList_toTree_test3_3 = TestCase (assertEqual
  "should return a binary search tree with correct properties"
  (Node 6 (Node 3 (Node 0 Empty_Node (Node 1 Empty_Node (Node 2 Empty_Node Empty_Node))) (Node 5 (Node 4 Empty_Node Empty_Node) Empty_Node)) (Node 9 (Node 7 Empty_Node (Node 8 Empty_Node Empty_Node)) Empty_Node))
  (convertList_toTree [2,1,8,0,7,4,9,5,3,6])
  )
convertList_toTree_test4_1 = TestCase (assertEqual
  "should return a binary search tree that looks like linked list"
  (Node 1 Empty_Node (Node 2 Empty_Node (Node 3 Empty_Node (Node 4 Empty_Node (Node 5 Empty_Node Empty_Node)))))
  (convertList_toTree [5,4,3,2,1])
  )
  
convertList_toTree_tests = TestList [
  TestLabel "Convert empty list into tree" convertList_toTree_test1_1,
  
  TestLabel "Convert singleton list into tree" convertList_toTree_test2_1,
  
  TestLabel "Convert unordered list into tree" convertList_toTree_test3_1,
  TestLabel "Convert unordered list into tree" convertList_toTree_test3_2,
  TestLabel "Convert unordered list into tree" convertList_toTree_test3_3,
  
  TestLabel "Convert descending sorted list into tree" convertList_toTree_test4_1
  ]

-- Unit Test for traverseTree_inOrder function

tests = TestList [
  ]
  
{-
:l binarySearchTree
runTestTT tests

SEARCH
PREDECESSOR
SUCCESSOR
MINIMUM
MAXIMUM
DELETE
-}