module Sim (sim) where

sim :: String -> String -> Bool
sim xs ys = n > 0
  where n = last $ dp xs ys

dp xs ys = foldl lineDP zero ys
  where
    zero :: [Int]
    zero =  scanl (\a c -> a + gap c) 0 xs

    lineDP :: [Int] -> Char -> [Int]
    lineDP line y =
      scanl update zero ls
      where
        zero :: Int
        zero = head line + gap y
        ls = zip3 line (tail line) xs
        update s (t0, t1, x) =
          maximum [ s + gap x, t1 + gap y, t0 + diff x y ]
        fst3 (a,_,_) = a

gap c = if paren c then 0 else p

diff c d
  | paren c = 0
  | paren d = 0
  | c == d  = q
  | otherwise = r

p = -3
q = 2
r = -3

paren '(' = True
paren ')' = True
paren '（' = True
paren '）' = True
paren _ = False
