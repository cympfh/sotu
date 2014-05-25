import System.IO
import System.Environment
import Control.Applicative
import Debug.Trace

data It = Text String | Icon String | Conj String | EOT deriving (Show, Ord, Eq)

main = do
  args <- getArgs
  let pref = head args
      out = args !! 1
  fs <- splitByEOT . parse . lines <$> readFile (pref ++ "/f")
  hd <- splitByEOT . parse . lines <$> readFile (pref ++ "/h")

  let (ffs, fhd, _) = foldl f ([], [], (0,0,0,0,0,0)) (zip fs hd)

  writeTweets ffs $ out ++ "/f"
  writeTweets fhd $ out ++ "/h"

    where
      f (acf, ach, es@(e0,e1,e2,e3,e4,e5)) (twf, twh)
        | hasUndef  = (acf, ach, es)
        | grow      = (twf : acf, twh : ach, (e0+d0, e1+d1, e2+d2, e3+d3, e4+d4, e5+d5))
        | otherwise = (acf, ach, es)
          where (d0, d1, d2, d3, d4, d5) = count twh
                grow = (e0 < 50 && d0 > 0) || (e1 < 50 && d1 > 0) || (e2 < 50 && d2 > 0) || (e3 < 50 && d3 > 0) || (e4 < 50 && d4 > 0) || (e5 < 50 && d5 > 0)
                hasUndef = any (== "undefined") $ map fromText $ filter textp twh


      count ls = c' $ map fromText $ filter textp ls
        where
          c' ls = foldl c'' (0,0,0,0,0,0) ls
            where
              c'' (a,b,c,d,e,f) "null"= (a+1,b,c,d,e,f)
              c'' (a,b,c,d,e,f) "yor" = (a,b+1,c,d,e,f)
              c'' (a,b,c,d,e,f) "ai"  = (a,b,c+1,d,e,f)
              c'' (a,b,c,d,e,f) "odo" = (a,b,c,d+1,e,f)
              c'' (a,b,c,d,e,f) "ika" = (a,b,c,d,e+1,f)
              c'' (a,b,c,d,e,f) "haj" = (a,b,c,d,e,f+1)
              c'' _ em = trace ("# unknown " ++ em) undefined

textp (Text _) = True
textp _ = False
fromText (Text x) = x
fromText _ = undefined

parse xs = p' xs []
  where
    p' [] ac = reverse ac
    p' ("<icon>" : x : _ : xs) ac = p' xs $ Icon x : ac
    p' ("<text>" : x : _ : xs) ac = p' xs $ Text x : ac
    p' ("<conj>" : x : _ : xs) ac = p' xs $ Conj x : ac
    p' ("__EOT__": xs) ac = p' xs $ EOT : ac
    p' _ _ = undefined

splitByEOT :: [It] -> [[It]]
splitByEOT [] = []
splitByEOT xs =
  let a = takeWhile ((/=) EOT) xs
      n = length a
      b = drop (n+1) xs
  in a : splitByEOT b

writeTweets :: [[It]] -> String -> IO ()
writeTweets ls file =
  mapM_ w ls
    where
      w :: [It] -> IO ()
      w ls = do
        mapM_ w' ls
        appendFile file "__EOT__\n"

      w' :: It -> IO ()
      w' (Text x) = do
        appendFile file "<text>\n"
        appendFile file $ x ++ "\n"
        appendFile file "</text>\n"
      w' (Icon x) = do
        appendFile file "<icon>\n"
        appendFile file $ x ++ "\n"
        appendFile file "</icon>\n"
      w' (Conj x) = do
        appendFile file "<conj>\n"
        appendFile file $ x ++ "\n"
        appendFile file "</conj>\n"
      w' EOT = do
        appendFile file "__EOT__\n"
