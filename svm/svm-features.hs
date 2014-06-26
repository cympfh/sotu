import System.IO
import System.Environment
import Control.Monad
import Control.Applicative
import Data.List
import Data.Array
import It
import PrintF

main :: IO ()
main = do
  args <- getArgs
  let dir = args !! 0
  fs <- splitByEOT . parse . lines <$> readFile (dir ++ "/f")
  hs <- splitByEOT . parse . lines <$> readFile (dir ++ "/h")
  text <- readFile (dir ++ "/u")
  let cs = nub $ sort text
      c_ar = listArray (0, length cs - 1) cs -- 表層文字
      us = splitByEOT $ parse $ lines text
  writeFile "/tmp/chars" (show c_ar)
  mapM_ (printF c_ar) (zip3 fs hs us)

    where
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
