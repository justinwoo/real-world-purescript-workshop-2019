module ZZZ.FFIWithTypes where

import Prelude

import Data.Array as Array
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console as Console
import Prim.Row as Row
import Prim.RowList as RL
import Record as Record
import Type.Prelude (class IsSymbol, Proxy(..), RLProxy(..), SProxy(..), reflectSymbol)
import ZZZ.Basics (URL)
import ZZZ.Rows (undefined)

foreign import kind RequestMethod
foreign import data GetRequest :: RequestMethod
foreign import data PostRequest :: RequestMethod

data Route (method :: RequestMethod) = Route URL

class GetMethod (method :: RequestMethod) where
  getMethod :: Route method -> String

foreign import kind EFFECT
foreign import data TERM :: EFFECT
foreign import data LOL :: EFFECT

newtype Eff (fx :: # EFFECT) a = Eff (Effect a)

lol :: Eff (lol :: LOL) Unit
lol = Eff $ pure unit

log :: String -> Eff (stdout :: TERM) Unit
log = Eff <<< Console.log

foreign import data Process :: Type

foreign import process :: Process

foreign import processExit :: Process -> Effect Unit

foreign import data JSX :: Type

type DivPropsRow =
  ( className :: String
  , apple :: Int
  , kiwi :: Boolean
  )

reactDivElementProperties :: forall input rest
   . Row.Union input rest DivPropsRow
  => { | input } -> JSX
reactDivElementProperties _ = undefined

type MyRecord =
  { apple :: String
  , banana :: String
  , kiwi :: String
  }

rowList :: forall r rl. RL.RowToList r rl => Proxy { | r } -> RLProxy rl
rowList _ = RLProxy

myRecordRL ::
  RLProxy
    (RL.Cons "apple" String
      (RL.Cons "banana" String
        (RL.Cons "kiwi" String
          RL.Nil)))
myRecordRL = rowList (Proxy :: Proxy MyRecord)

class Keys (rl :: RL.RowList) where
  keysImpl :: RLProxy rl -> Array String

instance keysNil :: Keys RL.Nil where
  keysImpl _ = []

instance keysCons ::
  ( IsSymbol name
  , Keys tail
  ) => Keys (RL.Cons name ty tail) where
  keysImpl _ =
    let
      curr = reflectSymbol (SProxy :: _ name)
      rest = keysImpl (RLProxy :: _ tail)
    in Array.cons curr rest

keys :: forall r rl
   . RL.RowToList r rl => Keys rl
  => Proxy { | r } -> Array String
keys _ = keysImpl (RLProxy :: _ rl)

foreign import data JSValue :: Type

foreign import jsonParse :: String -> Effect JSValue

newtype Error = Error String

class DecodeJSValue a where
  decode :: JSValue -> Either Error a

foreign import _readString :: forall e a
   . (e -> Either e a)
  -> (a -> Either e a)
  -> JSValue -> Either e a

readString :: JSValue -> Either Error String
readString = _readString Left Right

instance decodeJSValueString :: DecodeJSValue String where
  decode = readString

instance decodeJSValueRecord ::
  ( RL.RowToList r rl
  , DecodeJSValueRecordFields rl r
  ) => DecodeJSValue { | r } where
  decode jsv = do
    case checkTypeOf jsv of
      "object" -> decodeFields (RLProxy :: _ rl) jsv
      x -> Left <<< Error $ "expected object, got " <> x

foreign import checkTypeOf :: JSValue -> String

class DecodeJSValueRecordFields (xs :: RL.RowList) (r :: # Type)
  | xs -> r where
  decodeFields :: RLProxy xs -> JSValue -> Either Error { | r }

instance decodeJSValueRecordFieldsNil :: DecodeJSValueRecordFields RL.Nil () where
  decodeFields _ _ = Right {}

instance decodeJSValueRecordFieldsCons ::
  ( IsSymbol name
  , Row.Cons name ty r' r
  , Row.Lacks name r'
  , DecodeJSValue ty
  , DecodeJSValueRecordFields tail r'
  ) => DecodeJSValueRecordFields (RL.Cons name ty tail) r where
  decodeFields _ jsv =
    Record.insert nameS
      <$> first
      <*> rest
    where
      nameS = SProxy :: _ name
      first = do
        prop <- readProp (reflectSymbol nameS) jsv
        decode prop
      rest = decodeFields (RLProxy :: _ tail) jsv

foreign import _readProp :: forall e a
   . (e -> Either e a)
  -> (a -> Either e a)
  -> String
  -> JSValue -> Either e a

readProp :: String -> JSValue -> Either Error JSValue
readProp = _readProp Left Right

result :: Effect (Either Error MyRecord)
result = decode <$> jsonParse """
{ "apple": "hello"
, "banana": "bye"
, "kiwi": "yes"
}
"""
