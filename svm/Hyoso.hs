module Hyoso (binHyoso) where

import Data.List
import Data.Array
import Debug.Trace

binHyoso :: (Array Int Char) -> String -> [Bool]
binHyoso ar str =
  [ i `elem` idxes | i <- [ n .. m] ]
    where
      (n, m) = bounds ar
      idxes = nub $ sort $ map find str
      find :: Char -> Int
      find c = binSearch c (n, m)
        where
          binSearch c (n, m)
            | n >= m = -1 -- not Found
            | c == x = k
            | c < x = binSearch c (n, k)
            | c > x = binSearch c (k+1, m)
            where
              k = (n + m) `div` 2
              x = ar ! k
