import Data.List
import System.IO
import System.Environment
import Control.Monad
import Control.Applicative ((<$>))
import Sim

main = do
  args <- getArgs
  lex   <- readLex (args !! 0)
  input <- lines <$> getContents
  forM_ input $ \icon -> putStrLn $ unwords $ ems lex icon

readLex fname = do
  ls <- lines <$> readFile fname
  return $ fst $ foldl update ([], "ex") ls
    where
      update (ac, label) x
        | take 2 x == "# "  = (ac, drop 2 x)
        | otherwise         = ((x, label) : ac, label)

ems :: [(String, String)] -> String -> [String]
ems lex icon =
  if ls == [] then ["undefined"] else ls
  where ls = nub [ e | (i2, e) <- lex, sim icon i2]
