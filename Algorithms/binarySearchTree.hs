import Test.HUnit

data Tree a = Empty_Node | Node a (Tree a) (Tree a) deriving (Eq, Show)

insert_tree :: (Ord a) => a -> Tree a -> Tree a
insert_tree x Empty_Node = Node x (Empty_Node) (Empty_Node)
insert_tree x (Node a leftTree rightTree)
  | (x == a) = Node a leftTree rightTree
  | (x < a) = Node a (insert_tree x leftTree) rightTree
  | (x > a) = Node a leftTree (insert_tree x rightTree)

test1_1 = TestCase (assertEqual
  "should create one node with the inserted value as key and two empty node as children"
  (Node 1 (Empty_Node) (Empty_Node))
  (insert_tree 1 Empty_Node)
  )
test2_1 = TestCase (assertEqual
  "should just ignore the inserted value since the keys must be unique"
  (Node 1 (Empty_Node) Empty_Node)
  (insert_tree 1 (Node 1 (Empty_Node) (Empty_Node)))
  )
test2_2 = TestCase (assertEqual
  "should insert a node to the left of current tree"
  (Node 2 (Node 1 Empty_Node Empty_Node) Empty_Node)
  (insert_tree 1 (Node 2 (Empty_Node) (Empty_Node)))
  )
test2_3 = TestCase (assertEqual
  "should insert a node to the right of current tree"
  (Node 1 Empty_Node (Node 2 Empty_Node Empty_Node))
  (insert_tree 2 (Node 1 (Empty_Node) (Empty_Node)))
  )
test3_1 = TestCase (assertEqual
  "should just ignore the inserted value since the keys must be unique"
  (Node 200 (Node 100 Empty_Node Empty_Node) Empty_Node)
  (insert_tree 200 (Node 200 (Node 100 (Empty_Node) (Empty_Node)) (Empty_Node)))
  )
test3_2 = TestCase (assertEqual
  "should insert a node to the right of left children"
  (Node 200 (Node 100 Empty_Node (Node 150 Empty_Node Empty_Node)) Empty_Node)
  (insert_tree 150 (Node 200 (Node 100 (Empty_Node) (Empty_Node)) (Empty_Node)))
  )
test3_3 = TestCase (assertEqual
  "should insert a node to the left of left children"
  (Node 200 (Node 100 (Node 50 Empty_Node Empty_Node) Empty_Node) Empty_Node)
  (insert_tree 50 (Node 200 (Node 100 (Empty_Node) (Empty_Node)) (Empty_Node)))
  )
test4_1 = TestCase (assertEqual
  "should just ignore the inserted value since the keys must be unique"
  (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node)))
  (insert_tree 200 (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node))))
  )
test4_2 = TestCase (assertEqual
  "should insert a node to the left of right children"
  (Node 200 Empty_Node (Node 300 (Node 250 Empty_Node Empty_Node) Empty_Node))
  (insert_tree 250 (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node))))
  )
test4_3 = TestCase (assertEqual
  "should insert a node to the right of right children"
  (Node 200 Empty_Node (Node 300 Empty_Node (Node 350 Empty_Node Empty_Node)))
  (insert_tree 350 (Node 200 (Empty_Node) (Node 300 (Empty_Node) (Empty_Node))))
  )
tests = TestList [
  TestLabel "Inserting to empty tree" test1_1,
  
  --tree doesn't have any duplicate key
  TestLabel "Inserting to a tree with no children, with value inserted equal to tree value" test2_1,
  --left children value should be less than parent value
  TestLabel "Inserting to a tree with no children, with value inserted less than tree value" test2_2,
  --right children value should be greater than parent value
  TestLabel "Inserting to a tree with no children, with value inserted greater than tree value" test2_2,
  
  TestLabel "Inserting to a tree with left children, with value inserted equal to tree value" test3_1,
  TestLabel "Inserting to a tree with left children, with value inserted less than tree value, but more than left children" test3_2,
  TestLabel "Inserting to a tree with left children, with value inserted less than tree value, and less than left children" test3_3,
  
  TestLabel "Inserting to a tree with right children, with value inserted equal to tree value" test4_1,
  TestLabel "Inserting to a tree with right children, with value inserted more than tree value, but less than right children" test4_2,
  TestLabel "Inserting to a tree with right children, with value inserted more than tree value, and more than right children" test4_3
  ]
{-
runTestTT tests

SEARCH
PREDECESSOR
SUCCESSOR
MINIMUM
MAXIMUM
DELETE
-}