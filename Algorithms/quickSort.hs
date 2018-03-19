{- QUICK-SORT will construct a new sorted list -}
quicksort :: (Ord a) => [a] -> [a]
-- if base case is achieved (empty list), just return it (the empty list)
quicksort [] = []
-- else partition the list into two part (using the head as the partition element):
quicksort (x:xs) =
  -- the smaller part which is a list sorted using QUICK-SORT
  -- that contains all element in the original list which is smaller than or equal to the element used as the partition
  let smallerSorted = quicksort (filter (<=x) xs)
  -- and the bigger part which is a list sorted using QUICK-SORT
  -- that contains all element in the original list which is bigger than the element used as the partition
      biggerSorted = quicksort (filter (>x) xs)
-- concatenate the smaller part, the partition element, and the bigger part (in that order) and return it
  in smallerSorted ++ [x] ++ biggerSorted
