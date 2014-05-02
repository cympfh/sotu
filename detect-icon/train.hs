import Char
import IOB
import Chunk

import Control.Applicative
import Control.Monad

(|>) x f = f x; infixl 1 |>

main = do
  ls <- lines <$> getContents
  ls |> map putIOB
     |> flip forM_ doline

  where
  doline :: [(Char, IOB.IOB)] -> IO ()
  doline l =
    l |> map (\(c, t) -> (c, t, kind c))
      |> chunk

