{-
  Purpose of writing this code:
    - become more comfortable with functional programming techniques
    - train my TDD
    - become more familiar with Binary Search Tree
-}

import Test.HUnit
{-
  To run test:
    go to directory containing this file (from bash or other cli)
    type this in cli (without the '$ '):
      $ ghci
      $ :l binarySearchTree
      $ runTestTT tests
-}

{-
  BST properties:
    - keys must be unique
    - left children is less than parent
    - right children is greater than parent
-}
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

-- untested functionality
getMinKey_ofTree :: (Ord a) => Tree a -> a
getMinKey_ofTree (Node v Empty_Node _) = v
getMinKey_ofTree (Node v leftTree rightTree) = getMinKey_ofTree leftTree

getMaxKey_ofTree :: (Ord a) => Tree a -> a
getMaxKey_ofTree (Node v _ Empty_Node) = v
getMaxKey_ofTree (Node v leftTree rightTree) = getMaxKey_ofTree rightTree

checkIf_key_exists_inTree :: (Ord a) => a -> Tree a -> Bool
checkIf_key_exists_inTree key Empty_Node = False
checkIf_key_exists_inTree key (Node v leftTree rightTree)
  | (key == v) = True
  | (key < v) = checkIf_key_exists_inTree key leftTree
  | (key > v) = checkIf_key_exists_inTree key rightTree

-- untested Zipper functionality
data Crumb a = LeftCrumb a (Tree a) | RightCrumb a (Tree a) deriving (Show)
type Breadcrumbs a = [Crumb a]
type Zipper a = (Tree a, Breadcrumbs a)

x -: f = f x

convertTree_toZipper :: Tree a -> Zipper a
convertTree_toZipper tree = (tree, [])

goLeft :: Zipper a -> Zipper a
goLeft (Node v leftTree rightTree, breadcrumbs) = (leftTree, LeftCrumb v rightTree:breadcrumbs)

goFarLeft :: Zipper a -> Zipper a
goFarLeft zipper@(Node v Empty_Node _, _) = zipper
goFarLeft zipper@(Node v _ _, _) = goFarLeft (goLeft zipper)

goRight :: Zipper a -> Zipper a
goRight (Node v leftTree rightTree, breadcrumbs) = (rightTree, RightCrumb v leftTree:breadcrumbs)

goFarRight :: Zipper a -> Zipper a
goFarRight zipper@(Node v _ Empty_Node, _) = zipper
goFarRight zipper@(Node v _ _, _) = goFarRight (goRight zipper)

goUp :: Zipper a -> Zipper a
goUp (leftTree, LeftCrumb v rightTree:breadcrumbs) = (Node v leftTree rightTree, breadcrumbs)
goUp (rightTree, RightCrumb v leftTree:breadcrumbs) = (Node v leftTree rightTree, breadcrumbs)

goTop :: Zipper a -> Zipper a
goTop (tree, []) = (tree, [])
goTop zipper = goTop (goUp zipper)

convertZipper_toTree :: Zipper a -> Tree a
convertZipper_toTree zipper =
  let zipperTop = goTop zipper
      (tree, _) = zipperTop
  in tree

getFocusValue_ofZipper :: Zipper a -> a
getFocusValue_ofZipper (Node v leftTree rightTree, breadcrumbs) = v

searchKey_inZipper :: (Ord a) => a -> Zipper a -> Zipper a
searchKey_inZipper key zipper
  | (key == v) = zipper
  | (key < v) = searchKey_inZipper key (goLeft zipper)
  | (key > v) = searchKey_inZipper key (goRight zipper)
  where v = getFocusValue_ofZipper zipper

-- unit test the functions below
goUp_untilCurrentNode_isRightChild_or_isRootNode :: Zipper a -> Zipper a
goUp_untilCurrentNode_isRightChild_or_isRootNode isRootNode@(tree, []) = isRootNode
goUp_untilCurrentNode_isRightChild_or_isRootNode isRightChild@(tree, RightCrumb _ _:_) = isRightChild
goUp_untilCurrentNode_isRightChild_or_isRootNode isLeftChild@(tree, LeftCrumb _ _:_)
  = isLeftChild -: goUp -: goUp_untilCurrentNode_isRightChild_or_isRootNode

getPredecessor :: Zipper a -> Zipper a
getPredecessor tree_withNoLeftChild@(Node _ Empty_Node _, _) = tree_withNoLeftChild -: goUp_untilCurrentNode_isRightChild_or_isRootNode -: goUp
getPredecessor tree_withLeftChild@(_, _) = tree_withLeftChild -: goLeft -: goFarRight

goUp_untilCurrentNode_isLeftChild_or_isRootNode :: Zipper a -> Zipper a
goUp_untilCurrentNode_isLeftChild_or_isRootNode isRootNode@(tree, []) = isRootNode
goUp_untilCurrentNode_isLeftChild_or_isRootNode isLeftChild@(tree, LeftCrumb _ _:_) = isLeftChild
goUp_untilCurrentNode_isLeftChild_or_isRootNode isRightChild@(tree, RightCrumb _ _:_)
  = isRightChild -: goUp -: goUp_untilCurrentNode_isLeftChild_or_isRootNode

getSuccessor :: Zipper a -> Zipper a
getSuccessor tree_withNoRightChild@(Node _ _ Empty_Node, _) = tree_withNoRightChild -: goUp_untilCurrentNode_isLeftChild_or_isRootNode -: goUp
getSuccessor tree_withRightChild@(_, _) = tree_withRightChild -: goRight -: goFarLeft

deleteFocusValue_ofZipper :: Zipper a -> Zipper a
deleteFocusValue_ofZipper tree_withNoChild@(Node _ Empty_Node Empty_Node, breadcrumbs) = (Empty_Node, breadcrumbs)
deleteFocusValue_ofZipper tree_withNoRightChild@(Node _ leftTree Empty_Node, breadcrumbs) = (leftTree, breadcrumbs)
deleteFocusValue_ofZipper tree_withNoLeftChild@(Node _ Empty_Node rightTree, breadcrumbs) = (rightTree, breadcrumbs)
deleteFocusValue_ofZipper zipper@(Node v leftTree rightTree, breadcrumbs) =
  (Node successorValue leftTree newRightTree, breadcrumbs)
  where
    zipper_asRoot = (Node v leftTree rightTree, [])
    successorZipper@(Node successorValue _ _, _) = getSuccessor zipper_asRoot
    (Node _ _ newRightTree, _) = (deleteFocusValue_ofZipper successorZipper) -: goTop

deleteKey_fromTree :: (Ord a) => a -> Tree a -> Tree a
deleteKey_fromTree key old_tree = new_tree
  where
    zipper = old_tree -: convertTree_toZipper
    zipper_focusedInKey = zipper -: (searchKey_inZipper key)
    zipper_afterKeyDeletion = zipper_focusedInKey -: deleteFocusValue_ofZipper
    new_tree = convertZipper_toTree zipper_afterKeyDeletion

-- untested OPTIONAL functionality
applyFunction_inOrder :: (a -> b) -> Tree a -> Tree b
applyFunction_inOrder f Empty_Node = Empty_Node
applyFunction_inOrder f (Node v Empty_Node Empty_Node) = (Node (f v) Empty_Node Empty_Node)
applyFunction_inOrder f (Node v leftTree rightTree) = (Node (f v) (applyFunction_inOrder f leftTree) (applyFunction_inOrder f rightTree))

instance Functor Tree where
  fmap = applyFunction_inOrder
  
---------------------------------------------------------------------------------------
--  U    U   NN    N   I   TTTTTTT         TTTTTTT  EEEEEE   SSSSS  TTTTTTT   SSSSS  --
--  U    U   N N   N   I      T               T     E       S          T     S       --
--  U    U   N  N  N   I      T               T     EEEEE    SSSS      T      SSSS   --
--  U    U   N   N N   I      T               T     E            S     T          S  --
--   UUUU    N    NN   I      T               T     EEEEEE  SSSSS      T     SSSSS   --
---------------------------------------------------------------------------------------

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
insert_tree_tests = [
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
  "should return a binary search tree with unique keys"
  (Node 1 Empty_Node (Node 2 Empty_Node (Node 3 Empty_Node (Node 4 Empty_Node (Node 5 Empty_Node Empty_Node)))))
  (convertList_toTree [1,2,3,4,5,5,4,3,2,1])
  )
convertList_toTree_test5_1 = TestCase (assertEqual
  "should return a binary search tree that looks like linked list"
  (Node 1 Empty_Node (Node 2 Empty_Node (Node 3 Empty_Node (Node 4 Empty_Node (Node 5 Empty_Node Empty_Node)))))
  (convertList_toTree [5,4,3,2,1])
  )
  
convertList_toTree_tests = [
  TestLabel "Convert empty list into tree" convertList_toTree_test1_1,
  
  TestLabel "Convert singleton list into tree" convertList_toTree_test2_1,
  
  TestLabel "Convert unordered list into tree" convertList_toTree_test3_1,
  TestLabel "Convert unordered list into tree" convertList_toTree_test3_2,
  TestLabel "Convert unordered list into tree" convertList_toTree_test3_3,
  
  TestLabel "Convert list with duplicate elements into tree" convertList_toTree_test4_1,
  
  TestLabel "Convert descending sorted list into tree" convertList_toTree_test5_1
  ]

-- Unit Test for traverseTree_inOrder function
traverseTree_inOrder_test1_1 = TestCase (assertEqual
  "should return an empty list"
  ([] :: [] Int)
  (traverseTree_inOrder (Empty_Node :: Tree Int))
  )
traverseTree_inOrder_test2_1 = TestCase (assertEqual
  "should return a singleton list"
  ([1])
  (traverseTree_inOrder (Node 1 (Empty_Node) (Empty_Node)))
  )
traverseTree_inOrder_test3_1 = TestCase (assertEqual
  "should return an ordered list"
  ([0,1,2,3,4,5,6,7,8,9])
  (traverseTree_inOrder (Node 6 (Node 3 (Node 0 Empty_Node (Node 1 Empty_Node (Node 2 Empty_Node Empty_Node))) (Node 5 (Node 4 Empty_Node Empty_Node) Empty_Node)) (Node 9 (Node 7 Empty_Node (Node 8 Empty_Node Empty_Node)) Empty_Node)))
  )
traverseTree_inOrder_test3_2 = TestCase (assertEqual
  "should return an ordered list"
  ([1,2,3,4,5])
  (traverseTree_inOrder (Node 1 Empty_Node (Node 2 Empty_Node (Node 3 Empty_Node (Node 4 Empty_Node (Node 5 Empty_Node Empty_Node))))))
  )
  
traverseTree_inOrder_tests = [
  TestLabel "Traversing empty node" traverseTree_inOrder_test1_1,
  
  TestLabel "Traversing a tree with only a single value node" traverseTree_inOrder_test2_1,
  
  TestLabel "Traversing a tree with many branches and leaves" traverseTree_inOrder_test3_1,
  TestLabel "Traversing a tree with many branches and leaves" traverseTree_inOrder_test3_2
  ]

-- Unit Test for deleteKey_fromTree function
tree_toBeDeleted = 
  (Node 50
    (Node 40 Empty_Node Empty_Node)
    (Node 70
      (Node 60
        (Empty_Node)
        (Node 65 Empty_Node Empty_Node))
      (Node 80
        (Node 75 Empty_Node Empty_Node)
        (Empty_Node))))
deleteKey_fromTree_test1_1 = TestCase (assertEqual
  "should replace the key with empty node"
  (Node 50
    (Node 40 Empty_Node Empty_Node)
    (Node 70
      (Node 60 Empty_Node Empty_Node)
      (Node 80
        (Node 75 Empty_Node Empty_Node)
        (Empty_Node)
      )))
  (deleteKey_fromTree 65 tree_toBeDeleted)
  )
deleteKey_fromTree_test1_2 = TestCase (assertEqual
  "should transplant the key's left children into the key's position"
  (Node 50
    (Node 40 Empty_Node Empty_Node)
    (Node 70
      (Node 60
        (Empty_Node)
        (Node 65 Empty_Node Empty_Node))
      (Node 75 Empty_Node Empty_Node)))
  (deleteKey_fromTree 80 tree_toBeDeleted)
  )
deleteKey_fromTree_test1_3 = TestCase (assertEqual
  "should transplant the key's right children into the key's position"
  (Node 50
    (Node 40 Empty_Node Empty_Node)
    (Node 70
      (Node 65 Empty_Node Empty_Node)
      (Node 80
        (Node 75 Empty_Node Empty_Node)
        (Empty_Node))))
  (deleteKey_fromTree 60 tree_toBeDeleted)
  )
deleteKey_fromTree_test1_4 = TestCase (assertEqual
  "should transplant the key's successor into the key's position and keep the properties of BST intact"
  (Node 50
    (Node 40 Empty_Node Empty_Node)
    (Node 75
      (Node 60
        (Empty_Node)
        (Node 65 Empty_Node Empty_Node))
      (Node 80 Empty_Node Empty_Node)))
  (deleteKey_fromTree 70 tree_toBeDeleted)
  )
deleteKey_fromTree_test1_5 = TestCase (assertEqual
  "should transplant the key's successor into the key's position and keep the properties of BST intact"
  (Node 60
    (Node 40 Empty_Node Empty_Node)
    (Node 70
      (Node 65 Empty_Node Empty_Node)
      (Node 80
        (Node 75 Empty_Node Empty_Node)
        (Empty_Node))))
  (deleteKey_fromTree 50 tree_toBeDeleted)
  )

deleteKey_fromTree_tests = [
  TestLabel "Deleting a key with no children" deleteKey_fromTree_test1_1,
  
  TestLabel "Deleting a key with left children only (no right children)" deleteKey_fromTree_test1_2,
  TestLabel "Deleting a key with right children only (no left children)" deleteKey_fromTree_test1_3,
  
  TestLabel "Deleting a key with left and right children" deleteKey_fromTree_test1_4,
  TestLabel "Deleting a key with left and right children" deleteKey_fromTree_test1_5
  ]

tests = TestList (concat [
  insert_tree_tests,
  convertList_toTree_tests,
  traverseTree_inOrder_tests,
  deleteKey_fromTree_tests
  ])