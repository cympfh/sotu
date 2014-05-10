import System.IO
import System.Environment
import Control.Monad
import Control.Applicative

data It = Icon String | Text String | Conj String | EOT deriving Show

icon (Icon _) = True
icon _ = False
text (Text _) = True
text _ = False
conj (Conj _) = True
conj _ = False

ofIt :: It -> String
ofIt (Icon x) = x
ofIt (Text x) = x
ofIt (Conj x) = x
ofIt EOT = undefined

main = do
  args <- getArgs
  fs <- splitByEOT <$> parse <$> lines <$> readFile (args !! 0)
  hs <- splitByEOT <$> parse <$> lines <$> readFile (args !! 1)
  print fs

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
      splitByEOT [] = [[]]
      splitByEOT xs = 
        let (a, rest) = split EOT xs
        in a : splitByEOT rest
          where
            split x [] = ([], [])
            split x (y:ys)
              | x == y    = ([], ys)
              | otherwise = 
