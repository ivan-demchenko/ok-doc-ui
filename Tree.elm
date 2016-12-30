module Tree exposing (..)

import Json.Decode exposing (..)

type alias Tree =
  { name: String
  , path: String
  , subs: Subs
  }

type Subs = Subs (List Tree)



decodeSubs : Decoder (List Tree)
decodeSubs = list decodeTree



decodeTree : Decoder Tree
decodeTree =
  map3 Tree
    (field "name" string)
    (field "path" string)
    (field "subs" (map Subs (lazy (\_ -> decodeSubs))))



empty : Tree
empty = Tree "Waiting..." "" (Subs [])
