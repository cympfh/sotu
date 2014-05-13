import System.IO
import System.Environment
import Control.Monad
import Control.Applicative
import It
import PrintF

main :: IO ()
main = do
  args <- getArgs
  em <- return $ args !! 0
  fs <- splitByEOT <$> parse <$> lines <$> readFile (args !! 1)
  hs <- splitByEOT <$> parse <$> lines <$> readFile (args !! 2)
  mapM_ (printF em) $ zip fs hs

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
