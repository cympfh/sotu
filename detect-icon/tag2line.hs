import System.Environment
import System.IO
import Control.Applicative

main = do
  args <- getArgs
  text <- readFile $ args !! 0
  tags <- lines <$> (readFile $ args !! 1)
  printT text tags

  where
  printT ('\n' : cs) xs = putStrLn "\n__EOT__" >> printT cs xs

  printT (c : cs) ("O" : "B" : xs) = putChar c >> putStr startTag  >> printT cs ("I" : xs)
  printT (c : cs) ("B" : xs@("B" : _)) = putStr startTag >> putChar c >> printT cs xs
  printT (c : cs) ("B" : xs@("I" : _)) = putStr startTag >> putChar c >> printT cs xs

  printT (c : cs) ("B" : "O" : xs) = putChar c >> putStr endTag >> printT cs ("O" : xs)
  printT (c : cs) ("I" : "O" : xs) = putChar c >> putStr endTag >> printT cs ("O" : xs)
  printT (c : cs) (_ : xs) = putChar c >> printT cs xs
  printT _ [] = return ()
  printT [] _ = return ()

  startTag = "\n<icon>\n"
  endTag = "\n</icon>\n"
