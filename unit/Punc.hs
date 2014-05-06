module Punc where

import Control.Monad

punc :: String -> [String]
punc xs = loop xs []

  where

  ls = "。、.,｡!?！？☆♪♡"
  p  = flip elem ls
  q  = not . p

  loop [] ac = reverse ac
  loop xs ac =
    let (xs0, xs1) = partition q xs
        (xs2, xs3) = partition p xs1
    in
      loop xs3 ((xs0 ++ xs2) : ac)

  partition pred xs = p' ([], xs)
    where
    p' (ac, []) = (reverse ac, [])
    p' (ac, x:xs)
      | pred x    = p' (x:ac, xs)
      | otherwise = (reverse ac, x:xs)
