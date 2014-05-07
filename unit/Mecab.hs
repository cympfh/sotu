module Mecab where

import Control.Monad
import Control.Applicative
import System.Process
import Text.Regex.Posix

mecab :: String -> IO ()
mecab str = do
  ls <- lines <$> readProcess "mecab" [] str
  let ls' = merge $ map (\(s, b) -> (s, conj b)) $ map (split '\t') $ init ls
  forM_ ls' printTag
  
  where
    conj b = b =~ "接続詞" || b =~ "接続助詞"
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
merge (x : xs) = x : merge xs

