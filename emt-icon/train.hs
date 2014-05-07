import System.IO
import System.Environment
import Control.Monad
import Control.Applicative
import Debug.Trace

main = do
  args <- getArgs
  t <- lines <$> readFile (args !! 0)
  h <- lines <$> readFile (args !! 1)
  let (a,b,c,d,e,f) = collect t h ([],[],[],[],[],[])

  putStrLn "# null"
  forM_ a putStrLn
  putStrLn "# yor"
  forM_ b putStrLn
  putStrLn "# ai"
  forM_ c putStrLn
  putStrLn "# odo"
  forM_ d putStrLn
  putStrLn "# ika"
  forM_ e putStrLn
  putStrLn "# haj"
  forM_ f putStrLn

collect [] _ ac = ac
collect (x:xs) (y:ys) ac
  | x == "<icon>" = collect (drop 2 xs) (drop 2 ys) $
                    update (head xs) (head ys) ac
  | otherwise     = collect xs ys ac
    where
      update i em (a,b,c,d,e,f) =
        case em of
          "null" -> (i:a, b, c, d, e, f)
          "yor"  -> (a, i:b, c, d, e, f)
          "ai"   -> (a, b, i:c, d, e, f)
          "odo"  -> (a, b, c, i:d, e, f)
          "ika"  -> (a, b, c, d, i:e, f)
          "haj"  -> (a, b, c, d, e, i:f)
          x      -> trace x undefined

