module ZZZ.Rows where

import Prelude

import Data.Symbol (class IsSymbol, SProxy(..))
import Prim.Row as Row
import Unsafe.Coerce (unsafeCoerce)

-- records
-- https://pursuit.purescript.org/builtins/docs/Prim#t:Record

-- from Prim ("builtins")
-- data Record :: # Type -> Type

type MyRecordA =
  { apple :: String
  , banana :: String
  }

type MyRecordB =
  Record
  ( apple :: String
  , banana :: String
  )

-- above two are the same

id1 :: MyRecordA -> MyRecordA
id1 = identity

id2 :: MyRecordA -> MyRecordB
id2 = identity

-- you can get what is inside
fn1 :: MyRecordA -> String
fn1 r = r.apple

-- you can manipulate what is inside
fn2 :: MyRecordA -> MyRecordA
fn2 r = r { apple = "no" }

-- rows
type RowA = ( apple :: String ) :: # Type

type RowB (r :: # Type) = ( banana :: String | r ) :: # Type

type RowC (r :: # Type -> # Type) = r ( banana :: String)

type RowD = RowB RowA :: # Type

undefined :: forall a. a
undefined = unsafeCoerce "demonstration purposes only"

get :: forall r r' l a
   . IsSymbol l
  => Row.Cons l a r' r
  => SProxy l -> { | r } -> a
get = undefined

-- result :: ?hole -- Hole 'hole' has the inferred type Int
result :: Int
result = get (SProxy :: _ "apple") { apple: 123 }
