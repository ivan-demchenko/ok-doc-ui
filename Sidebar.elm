module Sidebar exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

type Msg
  = Choose Int
  | GotSections (Result Http.Error SectionsList)

type alias SectionsList =
    List (Int, String)

type alias Model =
    { items : SectionsList
    , selected : Int
    }

decodeModel : Decode.Decoder SectionsList
decodeModel = Decode.list


getSections : Http.Request SectionsList
getSections =
    let
      url = "https://runkit.io/raqystyle/582e188c29c74b001477e5cd/branches/master/sections"
    in
      Http.get url decodeModel

fetchSections : Cmd Msg
fetchSections = 
    Http.send GotSections getSections


init : Model
init =
    { items = List.map (\x -> (x, "Section " ++ toString x)) [1..10]
    , selected = 0
    }


update : Msg -> Model -> Model
update msg mdl =
    case msg of
        Choose iid ->
            { mdl | selected = iid }

        GotSections err sections ->
            { mdl | items = sections }


renderItem : (Int, String) -> Html Msg
renderItem (id, name) =
    li [ onClick (Choose id) ] [
        text name
    ]


view : Model -> Html Msg
view model =
    aside [] (List.map renderItem model.items)