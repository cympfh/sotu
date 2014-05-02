module Chunk(chunk) where

import Control.Monad
import Data.Maybe
import Data.List

(|>) x f = f x; infixl 1 |>

chunk ls =

  five |> map seh
       |> map (\ls -> ls |> filter isJust |> map fromJust |> intercalate "\t")
       |> flip forM_ putStrLn

  where
  ls' = map Just ls
  p1 = Nothing : ls'
  p2 = Nothing : Nothing : ls'
  n1 = drop 1 ls' ++ [Nothing]
  n2 = drop 2 ls' ++ [Nothing, Nothing]

  five = zip3 ls' (zip p1 p2) (zip n1 n2)

  seh (c, (p1, p2), (n1, n2)) =
    [ Just $ target c
    , char p2 "w[-2]="
    , char p1 "w[-1]="
    , char c "w[0]="
    , char n1 "w[1]="
    , char n2 "w[2]="

    , charCombine p1 c "w[-1|0]="
    , charCombine c n1 "w[0|1]="

    , pos p2 "pos[-2]="
    , pos p1 "pos[-1]="
    , pos c  "pos[0]="
    , pos n1 "pos[1]="
    , pos n2 "pos[2]="

    , posCombine [p2, p1] "pos[-2|-1]="
    , posCombine [p1,  c] "pos[-1|0]="
    , posCombine [c , n1] "pos[0|1]="
    , posCombine [n1, n2] "pos[1|2]="

    , posCombine [p2, p1, c] "pos[-2|-1|0]="
    , posCombine [p1, c, n1] "pos[-1|0|1]="
    , posCombine [c, p1, p2] "pos[0|1|2]="

    , mark
    ]
    where mark = if isNothing p1 then Just "__BOS__" else if isNothing n2 then Just "__EOS__" else Nothing

  target (Just (_, t, _)) = show t

  char Nothing _ = Nothing
  char (Just (c, t, k)) pref = Just $ pref ++ (c : "")

  charCombine Nothing _ _ = Nothing
  charCombine _ Nothing _ = Nothing
  charCombine (Just (c1,_,_)) (Just (c2,_,_)) pref = Just $ pref ++ (c1 : "") ++ "|" ++ (c2 : "")

  posCombine ls pref
    | any isNothing ls = Nothing
    | otherwise        = Just $ (++) pref $ intercalate "|" $ map (\(_,_,k) -> show k)  $ map fromJust ls

  pos Nothing _ = Nothing
  pos (Just (_,_,k)) pref = Just $ pref ++ show k

