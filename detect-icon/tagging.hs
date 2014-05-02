import Char
import IOB
import Chunk

import Control.Applicative
import Control.Monad

(|>) x f = f x; infixl 1 |>

main = do
  ls <- lines <$> getContents
  forM_ ls detect

detect :: String -> IO ()
detect l =
  l |> putIOB |> map (\(c, t) -> (c, t, kind c)) |> chunk
