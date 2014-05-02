module Char (kind) where

import Data.Char
import Data.List

data CharKind =
    Hiragana
  | Katakana
  | Kanji
  | Number
  | SmallAlphabet
  | LargeAlphabet
  | Greek
  | SpaceChar
  | Punctuation
  | Parenthesis
  | Hyphen
  | Others
    deriving (Show, Eq, Ord)

kind :: Char -> CharKind
kind c
  | 'ぁ' <= c && c <= 'ん'  = Hiragana
  | 'ァ' <= c && c <= 'ン'  = Katakana
  | '一' <= c && c <= '龠'  = Kanji
  | '0' <= c && c <= '9'    = Number
  | '０' <= c && c <= '９'  = Number
  | 'a' <= c && c <= 'z'    = SmallAlphabet
  | 'A' <= c && c <= 'Z'    = LargeAlphabet
  | 'α' <= c && c <= 'ω'    = Greek
  | 'Α' <= c && c <= 'Ω'    = Greek
  | c == ' ' || c == '　'   = SpaceChar
  | c `elem` "。、.,．，"   = Punctuation
  | c `elem` "()（）「」"   = Parenthesis
  | c `elem` "ー−-"         = Hyphen
  | otherwise               = Others

