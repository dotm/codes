{-
  Purpose of writing this code:
    - become more comfortable with functional programming techniques
    - train my TDD
    - become more familiar with Binary Search Tree
-}

import Test.HUnit
{-
  To run test:
    install ghci and HUnit
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

convertTree_toZipper :: Tree a -> Either String (Zipper a)
convertTree_toZipper tree = Right (tree, [])

goLeft :: Zipper a -> Either String (Zipper a)
goLeft (Empty_Node,_) = Left "Congrats! You fell off the tree! (Function: goLeft)"
goLeft (Node v leftTree rightTree, breadcrumbs) = Right (leftTree, LeftCrumb v rightTree:breadcrumbs)

goFarLeft :: Zipper a -> Either String (Zipper a)
goFarLeft (Empty_Node,_) = Left "There is no tree... (Function: goFarLeft)"
goFarLeft zipper@(Node v Empty_Node _, _) = Right zipper
goFarLeft zipper@(Node v _ _, _) = (goLeft zipper) >>= goFarLeft

goRight :: Zipper a -> Either String (Zipper a)
goRight (Empty_Node,_) = Left "Congrats! You fell off the tree! (Function: goRight)"
goRight (Node v leftTree rightTree, breadcrumbs) = Right (rightTree, RightCrumb v leftTree:breadcrumbs)

goFarRight :: Zipper a -> Either String (Zipper a)
goFarRight (Empty_Node,_) = Left "There is no tree... (Function: goFarRight)"
goFarRight zipper@(Node v _ Empty_Node, _) = Right zipper
goFarRight zipper@(Node v _ _, _) = (goRight zipper) >>= goFarRight

goUp :: Zipper a -> Either String (Zipper a)
goUp (_,[]) = Left "TFW you are at the top and can go up no more... (Function: goUp)"
goUp (leftTree, LeftCrumb v rightTree:breadcrumbs) = Right (Node v leftTree rightTree, breadcrumbs)
goUp (rightTree, RightCrumb v leftTree:breadcrumbs) = Right (Node v leftTree rightTree, breadcrumbs)

goTop :: Zipper a -> Either String (Zipper a)
goTop (tree, []) = Right (tree, [])
goTop zipper = (goUp zipper) >>= goTop

convertZipper_toTree :: Zipper a -> Either String (Tree a)
convertZipper_toTree zipper =
  let zipperTop = goTop zipper
  in
    case zipperTop of
      Right (tree, _) -> Right tree
      Left _ -> Left "There is no tree... (Function: convertZipper_toTree)"

getFocusValue_ofZipper :: Zipper a -> Either String a
getFocusValue_ofZipper (Empty_Node, breadcrumbs) = Left "You're focusing on an empty node"
getFocusValue_ofZipper (Node v leftTree rightTree, breadcrumbs) = Right v

searchKey_inZipper :: (Ord a) => a -> Zipper a -> Either String (Zipper a)
searchKey_inZipper key (Empty_Node,_) = Left "No key like that is in this tree... (Function: searchKey_inZipper)"
searchKey_inZipper key zipper
  | (key == v) = Right zipper
  | (key < v) = Right zipper >>= goLeft >>= (searchKey_inZipper key)
  | (key > v) = Right zipper >>= goRight >>= (searchKey_inZipper key)
  where Right v = getFocusValue_ofZipper zipper

--core functionality of BST below is already tested
goUp_untilCurrentNode_isRightChild :: Zipper a -> Either String (Zipper a)
goUp_untilCurrentNode_isRightChild isRootNode@(tree, []) = Left "Node not found"
goUp_untilCurrentNode_isRightChild isRightChild@(tree, RightCrumb _ _:_) = Right isRightChild
goUp_untilCurrentNode_isRightChild isLeftChild@(tree, LeftCrumb _ _:_) = (Right isLeftChild) >>= goUp >>= goUp_untilCurrentNode_isRightChild

getPredecessor :: (Show a) => Zipper a -> Either String (Zipper a)
getPredecessor tree_withNoLeftChild@(Node focusValue Empty_Node _, _) = 
  let result = (Right tree_withNoLeftChild) >>= goUp_untilCurrentNode_isRightChild >>= goUp
  in
    case result of
      Right zipper -> Right zipper
      Left _ -> Left ("No predecessor found for " ++ (show focusValue) ++ ". (Function: getPredecessor)")
getPredecessor tree_withLeftChild@(_, _) = (Right tree_withLeftChild) >>= goLeft >>= goFarRight

goUp_untilCurrentNode_isLeftChild :: Zipper a -> Either String (Zipper a)
goUp_untilCurrentNode_isLeftChild isRootNode@(tree, []) = Left "Node not found"
goUp_untilCurrentNode_isLeftChild isLeftChild@(tree, LeftCrumb _ _:_) = Right isLeftChild
goUp_untilCurrentNode_isLeftChild isRightChild@(tree, RightCrumb _ _:_) = (Right isRightChild) >>= goUp >>= goUp_untilCurrentNode_isLeftChild

getSuccessor :: (Show a) => Zipper a -> Either String (Zipper a)
getSuccessor tree_withNoRightChild@(Node focusValue _ Empty_Node, _) =
  let result = (Right tree_withNoRightChild) >>= goUp_untilCurrentNode_isLeftChild >>= goUp
  in
    case result of
      Right zipper -> Right zipper
      Left _ -> Left ("No successor found for " ++ (show focusValue) ++ ". (Function: getSuccessor)")
getSuccessor tree_withRightChild@(_, _) = (Right tree_withRightChild) >>= goRight >>= goFarLeft

deleteFocusValue_ofZipper :: (Show a) => Zipper a -> Either String (Zipper a)
deleteFocusValue_ofZipper tree_withNoChild@(Node _ Empty_Node Empty_Node, breadcrumbs) = Right (Empty_Node, breadcrumbs)
deleteFocusValue_ofZipper tree_withNoRightChild@(Node _ leftTree Empty_Node, breadcrumbs) = Right (leftTree, breadcrumbs)
deleteFocusValue_ofZipper tree_withNoLeftChild@(Node _ Empty_Node rightTree, breadcrumbs) = Right (rightTree, breadcrumbs)
deleteFocusValue_ofZipper zipper@(Node v leftTree rightTree, breadcrumbs) =
  Right (Node successorValue leftTree newRightTree, breadcrumbs)
  where
    zipper_asRoot = (Node v leftTree rightTree, [])
    Right successorZipper@(Node successorValue _ _, _) = getSuccessor zipper_asRoot
    Right (Node _ _ newRightTree, _) = (Right successorZipper) >>= deleteFocusValue_ofZipper >>= goTop

deleteKey_fromTree :: (Ord a, Show a) => a -> Tree a -> Either String (Tree a)
deleteKey_fromTree key old_tree = new_tree
  where
    zipper = (Right old_tree) >>= convertTree_toZipper
    zipper_focusedInKey = zipper >>= (searchKey_inZipper key)
    zipper_afterKeyDeletion = zipper_focusedInKey >>= deleteFocusValue_ofZipper
    new_tree = zipper_afterKeyDeletion >>= convertZipper_toTree

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

-- Unit Test for getPredecessor function
zipper_usedToTest_getPredecessor = 
  (Right
    (Node 6 
      (Node 3 
        (Node 0
          Empty_Node
          (Node 1
            Empty_Node
            (Node 2 Empty_Node Empty_Node)))
        (Node 5
          (Node 4 Empty_Node Empty_Node)
          Empty_Node))
      (Node 9
        (Node 7
          Empty_Node
          (Node 8 Empty_Node Empty_Node))
        Empty_Node)
    ,[])
  )

getPredecessor_test1_1 = TestCase (assertEqual
  "should go up to the nearest node that is a right child of its parent, and then return said parent of that node"
  (Right 6)
  (zipper_usedToTest_getPredecessor >>= (searchKey_inZipper 7) >>= getPredecessor >>= getFocusValue_ofZipper)
  )
getPredecessor_test1_2 = TestCase (assertEqual
  "should just return the parent of that node (because the current tree under focus is already a right child)"
  (Right 7)
  (zipper_usedToTest_getPredecessor >>= (searchKey_inZipper 8) >>= getPredecessor >>= getFocusValue_ofZipper)
  )
getPredecessor_test1_3 = TestCase (assertEqual
  "should return the left child"
  (Right 4)
  (zipper_usedToTest_getPredecessor >>= (searchKey_inZipper 5) >>= getPredecessor >>= getFocusValue_ofZipper)
  )
getPredecessor_test1_4 = TestCase (assertEqual
  "should return the right-most child of its left child"
  (Right 2)
  (zipper_usedToTest_getPredecessor >>= (searchKey_inZipper 3) >>= getPredecessor >>= getFocusValue_ofZipper)
  )
  
getPredecessor_tests = [
  TestLabel "get predecessor of the current tree in the zipper focus, if the tree has no left child and is a left child" getPredecessor_test1_1,
  TestLabel "get predecessor of the current tree in the zipper focus, if the tree has no left child and is a right child" getPredecessor_test1_2,
  
  TestLabel "get predecessor of the current tree in the zipper focus, if the tree has a left child which in turn has no right child" getPredecessor_test1_3,
  TestLabel "get predecessor of the current tree in the zipper focus, if the tree has a left child which in turn has a right child" getPredecessor_test1_4
  ]
  
-- Unit Test for getSuccessor function
zipper_usedToTest_getSuccessor = 
  (Right
    (Node 3
      (Node 0
        Empty_Node 
        (Node 2
          (Node 1 Empty_Node Empty_Node)
          Empty_Node))
      (Node 6 
        (Node 4
          Empty_Node
          (Node 5 Empty_Node Empty_Node))
        (Node 9
          (Node 8
            (Node 7 Empty_Node Empty_Node)
            Empty_Node)
          Empty_Node))
    ,[])
  )

getSuccessor_test1_1 = TestCase (assertEqual
  "should go up to the nearest node that is a left child of its parent, and then return said parent of that node"
  (Right 6)
  (zipper_usedToTest_getSuccessor >>= (searchKey_inZipper 5) >>= getSuccessor >>= getFocusValue_ofZipper)
  )
getSuccessor_test1_2 = TestCase (assertEqual
  "should just return the parent of that node (because the current tree under focus is already a left child)"
  (Right 2)
  (zipper_usedToTest_getSuccessor >>= (searchKey_inZipper 1) >>= getSuccessor >>= getFocusValue_ofZipper)
  )
getSuccessor_test1_3 = TestCase (assertEqual
  "should return the right child"
  (Right 5)
  (zipper_usedToTest_getSuccessor >>= (searchKey_inZipper 4) >>= getSuccessor >>= getFocusValue_ofZipper)
  )
getSuccessor_test1_4 = TestCase (assertEqual
  "should return the left-most child of its right child"
  (Right 7)
  (zipper_usedToTest_getSuccessor >>= (searchKey_inZipper 6) >>= getSuccessor >>= getFocusValue_ofZipper)
  )

getSuccessor_tests = [
  TestLabel "get successor of the current tree in the zipper focus, if the tree has no right child and is a right child" getSuccessor_test1_1,
  TestLabel "get successor of the current tree in the zipper focus, if the tree has no right child and is a left child" getSuccessor_test1_2,
  
  TestLabel "get successor of the current tree in the zipper focus, if the tree has a right child which in turn has no left child" getSuccessor_test1_3,
  TestLabel "get successor of the current tree in the zipper focus, if the tree has a right child which in turn has a left child" getSuccessor_test1_4
  ]
  
-- Unit Test for deleteKey_fromTree function
tree_toBeDeleted =
  Right
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
  (Right
    (Node 50
      (Node 40 Empty_Node Empty_Node)
      (Node 70
        (Node 60 Empty_Node Empty_Node)
        (Node 80
          (Node 75 Empty_Node Empty_Node)
          (Empty_Node)
        ))))
  (tree_toBeDeleted >>= (deleteKey_fromTree 65))
  )
deleteKey_fromTree_test1_2 = TestCase (assertEqual
  "should transplant the key's left children into the key's position"
  (Right
    (Node 50
      (Node 40 Empty_Node Empty_Node)
      (Node 70
        (Node 60
          (Empty_Node)
          (Node 65 Empty_Node Empty_Node))
        (Node 75 Empty_Node Empty_Node))))
  (tree_toBeDeleted >>= (deleteKey_fromTree 80))
  )
deleteKey_fromTree_test1_3 = TestCase (assertEqual
  "should transplant the key's right children into the key's position"
  (Right
    (Node 50
      (Node 40 Empty_Node Empty_Node)
      (Node 70
        (Node 65 Empty_Node Empty_Node)
        (Node 80
          (Node 75 Empty_Node Empty_Node)
          (Empty_Node)))))
  (tree_toBeDeleted >>= (deleteKey_fromTree 60))
  )
deleteKey_fromTree_test1_4 = TestCase (assertEqual
  "should transplant the key's successor into the key's position and keep the properties of BST intact"
  (Right
    (Node 50
      (Node 40 Empty_Node Empty_Node)
      (Node 75
        (Node 60
          (Empty_Node)
          (Node 65 Empty_Node Empty_Node))
        (Node 80 Empty_Node Empty_Node))))
  (tree_toBeDeleted >>= (deleteKey_fromTree 70))
  )
deleteKey_fromTree_test1_5 = TestCase (assertEqual
  "should transplant the key's successor into the key's position and keep the properties of BST intact"
  (Right
    (Node 60
      (Node 40 Empty_Node Empty_Node)
      (Node 70
        (Node 65 Empty_Node Empty_Node)
        (Node 80
          (Node 75 Empty_Node Empty_Node)
          (Empty_Node)))))
  (tree_toBeDeleted >>= (deleteKey_fromTree 50))
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
  getPredecessor_tests,
  getSuccessor_tests,
  deleteKey_fromTree_tests
  ])