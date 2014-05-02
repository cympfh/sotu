import Control.Monad
import Control.Applicative
import System.Process
import Text.Regex.Posix

main = do
  ls <- lines <$> getContents
  loop ls

  where

  loop :: [String] -> IO ()

  loop [] = return ()
  loop ("" : xs) = loop xs

  loop ("__EOT__": xs) = do
    putStrLn "__EOT__"
    loop xs

  loop ls @ ("<icon>" : _) = do
    putStr $ unlines $ take 3 ls
    loop $ drop 3 ls

  loop (x : xs) = do
    mecab x
    loop xs

mecab :: String -> IO ()
mecab str = do
  ls <- lines <$> readProcess "mecab" [] str
  let ls' = punc $ merge $ map (\(s, b) -> (s, b =~ "接続詞" :: Bool)) $ map (split '\t') $ init ls
  forM_ ls' printTag
  
  where
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

punc [] = []
punc ((s, False) : rest) = punc' s ++ punc rest
punc (x:xs) = x : punc xs


