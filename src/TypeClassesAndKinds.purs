module ZZZ.TypeClassesAndKinds where

import Data.Symbol (SProxy(..), reflectSymbol)
import ZZZ.Basics (URL(..))

-- regular Type classes

class Unwrap t a | t -> a where
  unwrap :: t -> a

instance unwrapURLInstance :: Unwrap URL String where
  unwrap (MkURL s) = s

class RodeoTypes input output | input -> output

instance rodeoIntString :: RodeoTypes Int String
instance rodeoStringBoolean :: RodeoTypes String Boolean

data Proxy s = Proxy

rodeoTypes :: forall input output
   . RodeoTypes input output
  => Proxy input -> Proxy output
rodeoTypes _ = Proxy

rodeoResult1 :: Proxy String
rodeoResult1 = rodeoTypes (Proxy :: Proxy Int)

-- rodeoResult2 :: Proxy ?hole
-- rodeoResult2 = rodeoTypes (Proxy :: Proxy String)

class MkProxy (proxy :: Type -> Type) where
  mkProxy :: forall a. proxy a

rodeoTypes' :: forall input output proxy
   . RodeoTypes input output
  => MkProxy proxy
  => proxy input -> proxy output
rodeoTypes' _ = mkProxy

----------

-- kinds

-- from Data.Symbol
-- data SProxy (sym :: Symbol) = SProxy

staticStringProxy :: SProxy "hello world"
staticStringProxy = SProxy

reflectedSymbolValue :: String
reflectedSymbolValue = reflectSymbol staticStringProxy

type IntToInt1 = Int -> Int

type Arrow = (->) :: Type -> Type -> Type
type FromInt = (->) Int :: Type -> Type
type IntToInt2 = FromInt Int :: Type

type EmptyRow = () :: # Type
type SingleRow = ( a :: String ) :: # Type
type SymbolRow = ( a :: "apple" ) :: # Symbol
