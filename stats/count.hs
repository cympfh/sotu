import Control.Applicative

main = do
  ls <- lines <$> getContents
  print $ loop ls (0, 0, 0, 0, 0, 0)
    where
      loop [] ac = ac
      loop ("<text>" : x : _ : xs) ac = loop xs (update x ac)
      loop (_ : xs) ac = loop xs ac

      update "null" (a,b,c,d,e,f)= (a+1,b,c,d,e,f)
      update "yor" (a,b,c,d,e,f) = (a,b+1,c,d,e,f)
      update "ai"  (a,b,c,d,e,f) = (a,b,c+1,d,e,f)
      update "odo" (a,b,c,d,e,f) = (a,b,c,d+1,e,f)
      update "ika" (a,b,c,d,e,f) = (a,b,c,d,e+1,f)
      update "haj" (a,b,c,d,e,f) = (a,b,c,d,e,f+1)
      update _ ac = ac
