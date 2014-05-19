module PrintF (printF) where

import It
import Em
import qualified Conj as C

import Data.Array
import Control.Monad

printF :: String -> ([It], [It]) -> IO ()

-- with target `em`
-- f :: [It] is features
-- h :: [It] is hand
printF em (f, h)
  | hasUndefined f = return ()
  | hasUndefined h = return ()
  | otherwise = printF' em (f, h)
    where
      hasUndefined = any (\it -> ofIt it == "undefined")

printF' em (f, h) = do
  let n = length h
  let ar = listArray (0, n-1) f
  forM_ (zip [0 .. n-1] h) $ \(i, it) ->
          case it of
            Text t  -> do
              putStr (target t)
              putStr " "
              printFeatureSet ar i
            otherwise -> return ()
    where
      target t = if t == em then "+1" else "-1"

printFeatureSet :: (Array Int It) -> Int -> IO ()
printFeatureSet ar i =
  putStrLn $ format $
    concat $
      [cur_t
      , prev_t, next_t

      , prev'_t, next'_t
      , prev_i, next_i
      , prev_c

      , mae_t, ato_t
      ]
    where
      -- 素性の選択!!
      -- select features !!
      --
      cur_t = getBinary text ar i

      prev_t = getBinary text ar (i-1)
      next_t = getBinary text ar (i+1)
      prev'_t = getBinary text ar (i-2)
      next'_t = getBinary text ar (i+2)
      prev_i = getBinary icon ar (i-1)
      next_i = getBinary icon ar (i+1)
      prev_c = C.getBinary ar (i-1)

      mae_t = getBinary text ar $ mae text ar (i-1)
      ato_t = getBinary text ar $ ato text ar (i+1)

      mae pred arr i
        | i < 0  = -1
        | pred (arr ! i) = i
        | otherwise      = mae pred arr (i-1)

      ato pred arr i
        | max < i        = i + 1
        | pred (arr ! i) = i
        | otherwise      = ato pred arr (i+1)
          where (_, max) = bounds arr

format :: [Bool] -> String
format bs = unwords $ map pairFormat ls
  where
    ls = zip [1..] bs
    pairFormat (idx, b) = show idx ++ ":" ++ (if b then "1" else "-1")

