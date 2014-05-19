module Em (getBinary) where

import Data.Array
import Debug.Trace
import It

dummy = "dummy" -- to Nothing

getIDs :: String -> [Int]
getIDs = map getID . words

  where
    getID :: String -> Int

    getID "null" = 0

    getID "yor" = 1
    getID "suk" = 1
    getID "yas" = 1
    getID "tak" = 1

    getID "ai"  = 2
    getID "iya" = 2
    getID "awa" = 2
    getID "kow" = 2

    getID "odo" = 3
    getID "ika" = 4
    getID "haj" = 5

    getID "dummy" = (-1)

    getID x = trace ("# getID: " ++ x) (-1) -- 単にサポートできていない感情タグかもしれないことに注意!!

-- "yor ai iya" -> [1, 2, 2] -> [1,2] -> [False, True, True, False, False, False]
emBinary :: String -> [Bool]
emBinary t = [ i `elem` ms | i <- [0 .. 5]] where ms = getIDs t

getBinary :: (It -> Bool) -> (Array Int It) -> Int -> [Bool]
getBinary test arr idx
  | idx < min || max < idx  = emBinary dummy
  | test (arr ! idx)        = emBinary $ ofIt (arr ! idx)
  | otherwise               = emBinary dummy
  where
    (min, max) = bounds arr
    hasUndefined = any (\it -> ofIt it == "undefined")
