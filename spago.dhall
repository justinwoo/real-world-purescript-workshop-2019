{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "rwps-workshop"
, dependencies =
    [ "aff"
    , "console"
    , "effect"
    , "functions"
    , "prelude"
    , "record"
    , "typelevel-prelude"
    ]
, packages =
    ./packages.dhall
}
