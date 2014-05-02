module IOB(putIOB, IOB) where

import Control.Applicative
import Control.Monad

data IOB = I | O | B deriving Show

putIOB :: String -> [(Char, IOB)]
putIOB ln = put' False ln []

  where

  -- True = inner
  put' True ('<' : '>' : rest) ac = put' False rest ac
  put' True (x : rest) ac = put' True rest $ (x, I) : ac

  -- False = outer
  put' False ('<' : '>' : x : rest) ac = put' True rest $ (x, B) : ac
  put' False (x : rest) ac = put' False rest $ (x, O) : ac

  put' _ [] ac = reverse ac

