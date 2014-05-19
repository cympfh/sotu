module Conj (getBinary) where

import It
import Data.Array
import Debug.Trace

getBinary :: (Array Int It) -> Int -> [Bool]
getBinary ar idx
  | idx < min || max < idx = bin (-1)
  | conj it        = getID $ ofIt it
  | otherwise      = bin (-1)
  where
    (min, max) = bounds ar
    it = ar ! idx

getID :: String -> [Bool]
-- "Other" -> [False,False,False,False,False,False,True]

getID "Add" = bin 0
getID "Cont" = bin 1
getID "Cause" = bin 2
getID "Appose" = bin 3
getID "Converse" = bin 4
getID "Exemp" = bin 5
getID "Other" = bin 6

getID x = trace ("# getBinary in svm/Conj.hs: "++x) undefined

bin n = map ((==) n) [0 .. 6]
