module Tree exposing (..)

import Json.Decode exposing (..)

type alias Tree =
  { id: Int
  , name: String
  , path: String
  , subs: Subs
  }

type Subs = Subs (List Tree)



decodeSubs : Decoder (List Tree)
decodeSubs = list decodeTree



decodeTree : Decoder Tree
decodeTree =
  map4 Tree
    (field "id" int)
    (field "name" string)
    (field "path" string)
    (field "subs" (map Subs (lazy (\_ -> decodeSubs))))



empty : Tree
empty = Tree 0 "Waiting..." "" (Subs [])
