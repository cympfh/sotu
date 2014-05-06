import Control.Monad
import Control.Applicative
import Punc
import Mecab

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
    flip forM_ mecab $ punc x
    loop xs
