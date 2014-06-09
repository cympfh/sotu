module PrintF (printF) where

import It
import Em
import qualified Conj as C

import Data.Array
import Control.Monad

printF :: ([It], [It], [It]) -> IO ()

-- f :: [It] is features
-- h :: [It] is hand
printF (f, h, u)
  | hasUndefined f = return ()
  | hasUndefined h = return ()
  | otherwise = printF' (f, h, u)
    where
      hasUndefined = any (\it -> ofIt it == "undefined")

printF' (f, h, u) = do
  let n = length h
  let ar = listArray (0, n-1) f
      ur = listArray (0, n-1) u
  forM_ (zip [0 .. n-1] h) $ \(i, it) ->
          case it of
            Text t  -> do
              putStr t
              putStr " "
              printFeatureSet ar ur i
              putStrLn $ "# " ++ ofIt (ur!i)
            otherwise -> return ()

printFeatureSet :: (Array Int It) -> (Array Int It) -> Int -> IO ()
printFeatureSet ar ur i =
  putStrLn $ format $
    concat $
      [ cur_t

      -- skip
      , before_1_t, before_2_t, before_3_t
      , after_1_t, after_2_t, after_3_t

      -- no skip
      , prev_i, next_i

      -- skip
      , before_1_c
      , after_1_c

      , sp , bikkuri, bar
      ]
    where
      --
      -- IMPORTANT
      --
      cur_t = getBinary text ar i

      raw = ofIt (ur ! i)
      sp = if length (filter (`elem` " 　") raw) > 0 then [True] else [False]
      bikkuri = if length (filter (`elem` "!！") raw) > 0 then [True] else [False]
      bar = if length (filter (`elem` "ー〜−") raw) > 0 then [True] else [False]

      before_1_t = getBinary text ar $ mae text ar i 1
      before_2_t = getBinary text ar $ mae text ar i 2
      before_3_t = getBinary text ar $ mae text ar i 3

      after_1_t = getBinary text ar $ ato text ar i 1
      after_2_t = getBinary text ar $ ato text ar i 2
      after_3_t = getBinary text ar $ ato text ar i 3

      prev_i = getBinary icon ar (i-1)
      next_i = getBinary icon ar (i+1)

      before_1_c = C.getBinary ar $ mae conj ar i 1
      after_1_c = C.getBinary ar $ ato conj ar i 1

      mae pred ar idx count =
        let idxes = iterate (mae' pred ar) idx
        in idxes !! count
          where
            mae' pred arr i
              | i < 0  = -1
              | pred (arr ! i) = i
              | otherwise      = mae' pred arr (i-1)

      ato pred ar idx count =
        let idxes = iterate (ato' pred ar) idx
        in idxes !! count
          where
            ato' pred arr i
              | max < i        = i + 1
              | pred (arr ! i) = i
              | otherwise      = ato' pred arr (i+1)
                where (_, max) = bounds arr

format :: [Bool] -> String
format bs = unwords $ map pairFormat ls
  where
    ls = zip [1..] bs
    pairFormat (idx, b) = show idx ++ ":" ++ (if b then "1" else "-1")

