module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

-- see output/Main/index.js
main :: Effect Unit
main = do
  log "Hello sailor!"
