module It where

data It = Icon String | Text String | Conj String | EOT deriving (Show, Eq)

-- test?

icon (Icon _) = True
icon _ = False
text (Text _) = True
text _ = False
conj (Conj _) = True
conj _ = False

-- getter

ofIt :: It -> String
ofIt (Icon x) = x
ofIt (Text x) = x
ofIt (Conj x) = x
ofIt EOT = undefined
