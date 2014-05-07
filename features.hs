import Control.Monad
import Control.Applicative
import System.Process

data It = Icon String | Text String | Conj String | EOT

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
  ls <- lines <$> getContents
  let ls' = parse ls
  icons <- eI $ map ofIt $ filter icon ls'
  texts <- eT $ map ofIt $ filter text ls'
  conjs <- eC $ map ofIt $ filter conj ls'
  loop ls' icons texts conjs

    where
      parse xs = p' xs []
        where
          p' [] ac = reverse ac
          p' ("<icon>" : x : _ : xs) ac = p' xs $ Icon x : ac
          p' ("<text>" : x : _ : xs) ac = p' xs $ Text x : ac
          p' ("<conj>" : x : _ : xs) ac = p' xs $ Conj x : ac
          p' ("__EOT__": xs) ac = p' xs $ EOT : ac
          p' _ _ = undefined

      loop :: [It] -> [String] -> [String] -> [String] -> IO ()

      loop [] _ _ _ = return ()

      loop (EOT:xs) is ts cs = do
        putStrLn "__EOT__"
        loop xs is ts cs

      loop ((Icon _) : xs) is ts cs = do
        putStrLn "<icon>"
        putStrLn $ head is
        putStrLn "</icon>"
        loop xs (tail is) ts cs

      loop ((Text _) : xs) is ts cs = do
        putStrLn "<text>"
        putStrLn $ head ts
        putStrLn "</text>"
        loop xs is (tail ts) cs

      loop ((Conj _) : xs) is ts cs = do
        putStrLn "<conj>"
        putStrLn $ head cs
        putStrLn "</conj>"
        loop xs is ts (tail cs)

eI :: [String] -> IO [String]
eI xs =
  lines <$> readProcess "./emt-icon/emt-icon.exe" ["./emt-icon/icon.lex"] (unlines xs)

eT :: [String] -> IO [String]
eT xs =
  lines <$> readProcess "./mlask/mlask.js" ["./mlask/"] (unlines xs)

eC :: [String] -> IO [String]
eC xs =
  lines <$> readProcess "./conj/conj" [] (unlines xs)


