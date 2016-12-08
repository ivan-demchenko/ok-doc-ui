module Tree exposing (..)

import Json.Decode exposing (..)

type alias Tree =
  { idx: Int
  , name: String
  , subs: Subs
  }

type Subs = Subs (List Tree)



decodeSubs : Decoder (List Tree)
decodeSubs = list decodeTree



decodeTree : Decoder Tree
decodeTree =
  map3 Tree
    (field "id" int)
    (field "name" string)
    (field "subs" (map Subs (lazy (\_ -> decodeSubs))))



empty : Tree
empty = Tree 0 "Waiting..." (Subs [])
