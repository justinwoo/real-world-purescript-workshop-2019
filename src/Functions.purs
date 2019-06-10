module ZZZ.Functions where

import Prelude

import Data.Function.Uncurried (Fn2, Fn3, Fn4, mkFn2, mkFn3, runFn2, runFn4)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff.Compat (mkEffectFn1)
import Effect.Console as Console
import Effect.Uncurried (EffectFn1, runEffectFn1)

-- Functions

add2 :: Int -> Int -> Int
add2 a b = a + b

add3 :: Int -> Int -> Int -> Int
add3 a b c = a + b + c

add4 :: Int -> Int -> Int -> Int -> Int
add4 a b c d = a + b + c + d

result1 :: Int
result1 = add2 1 2

-- Uncurried Functions

add2Fn2 :: Fn2 Int Int Int
add2Fn2 = mkFn2 add2

add3Fn3 :: Fn3 Int Int Int Int
add3Fn3 = mkFn3 add3

result2 :: Int
result2 = runFn2 add2Fn2 1 2

foreign import jsAdd4 :: Fn4 Int Int Int Int Int

result3 :: Int
result3 = runFn4 jsAdd4 1 2 3 4

-- Effects
logInt :: Int -> Effect Unit
logInt i = Console.logShow i

foreign import jsLogInt :: Int -> Effect Unit

-- Uncurried Effect Functions
unthunkedLogInt :: EffectFn1 Int Unit
unthunkedLogInt = mkEffectFn1 logInt

foreign import jsUnthunkedLogInt :: EffectFn1 Int Unit

rethunkedLogInt :: Int -> Effect Unit
rethunkedLogInt i = runEffectFn1 jsUnthunkedLogInt i

foreign import _index :: forall a. (a -> Maybe a) -> Maybe a -> Int -> Array a -> Maybe a

index :: forall a. Int -> Array a -> Maybe a
index = _index Just Nothing
