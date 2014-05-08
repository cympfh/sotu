import System.Environment
import System.IO
import Control.Applicative

main = do
  args <- getArgs
  text <- readFile $ args !! 0
  tags <- lines <$> (readFile $ args !! 1)
  let tags' = filter (`elem` ["B","I","O"]) tags
  printT text tags'

printT :: String -> [String] -> IO ()

-- 顔文字がIで始まってることになっちゃう時がある
printT ('\n' : cs) ("I":xs) = do
  putStrLn endTag
  putStrLn eot
  printT cs ("B":xs)

printT (c : '\n' : cs) ("O" : "B" : xs) = do
  putChar c
  putStrLn eot
  printT cs ("B":xs)

printT ('\n' : cs) xs = putStrLn eot >> printT cs xs

printT (c : cs) ("O" : "B" : xs) = do
  putChar c
  putStr startTag
  printT cs ("I" : xs)

printT (c : cs) ("B" : "B" : xs) = do
  putStr startTag
  putChar c
  putStr endTag
  printT cs ("B":xs)

printT (c : cs) ("B" : "I" : xs) = do
  putStr startTag
  putChar c
  printT cs ("I":xs)

printT (c : cs) ("B" : "O" : xs) = do
  putChar c
  putStr endTag
  printT cs ("O" : xs)

printT (c : cs) ("I" : "O" : xs) = do
  putChar c
  putStr endTag
  printT cs ("O" : xs)

-- end of file
printT (c:_) ["B"] = do
  putChar c
  putStrLn endTag
  putStrLn eot

printT (c:_) ["I"] = do
  putChar c
  putStrLn endTag
  putStrLn eot

printT (c:_) ["O"] = putChar c >> putStrLn eot

printT (c : cs) (x : xs) = putChar c >> printT cs xs

printT cs [] = return ()
printT [] xs = return ()

startTag = "\n<icon>\n"
endTag = "\n</icon>\n"
eot = "\n__EOT__"
