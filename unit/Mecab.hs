module Mecab where

import Control.Monad
import Control.Applicative
import System.Process
-- import Text.Regex.Posix
import Data.List

mecab :: String -> IO ()
mecab str = do
  ls <- lines <$> readProcess "mecab" [] str
  flip forM_ printTag $
    filter hasSense $
    merge $
    map (\(s, b) -> (s, conj b)) $ map (split '\t') $ init ls
  
  where
    conj :: String -> Bool
    conj b = "接続詞" `isInfixOf` b || "接続助詞" `isInfixOf` b

    printTag (s, b) =
      if b then putStrLn "<conj>" >> putStrLn s >> putStrLn "</conj>"
           else putStrLn "<text>" >> putStrLn s >> putStrLn "</text>"

split c xs = split' c xs []
  where
  split' c [] ac = (reverse ac, [])
  split' c (x:xs) ac
    | c == x     = (reverse ac, xs)
    | otherwise  = split' c xs $ x : ac

merge :: [(String, Bool)] -> [(String, Bool)]
merge [] = []
merge [x] = [x]
merge ((s1, False) : (s2, False) : rest) = merge $ (s1 ++ s2, False) : rest
merge ((s1, False) : (s2, True) : rest) =
  (s1, False) : (s2, True) : (merge ((s1 ++ s2, False) : rest))
merge (x : xs) = x : merge xs

-- remove Text contains just punctuation
hasSense (_, True) = True
hasSense (x, False) = length x > 1

