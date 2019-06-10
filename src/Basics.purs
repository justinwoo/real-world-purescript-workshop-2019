module ZZZ.Basics where

import Prelude

-- Regular Types

-- a type alias
type StringAlias = String

stringAliasValue :: StringAlias
stringAliasValue = "Hello"

-- newtypes, which simply wrap a type but give type safety in compilation
newtype URL = MkURL String

urlValue :: URL
urlValue = MkURL "https://google.com"

-- data types, with actual constructors in runtime
data URLorCode
  = IsURL String
  | IsCode String

urlOrCodeValue :: URLorCode
urlOrCodeValue = IsCode "banana"

----------

-- regular Functions

unwrapURL :: URL -> String
unwrapURL (MkURL s) = s

isCode :: URLorCode -> Boolean
isCode (IsCode _) = true
isCode (IsURL _) = false

isCode' :: URLorCode -> Boolean
isCode' x = case x of
  IsCode _ -> true
  _ -> false

isCode'' :: URLorCode -> Boolean
isCode'' x
  | IsCode _ <- x = true
  | otherwise = false

----------

-- Records
type MyRecord =
  { apple :: String
  , banana :: String
  , kiwi :: String
  }

-- more on this in later sections...
