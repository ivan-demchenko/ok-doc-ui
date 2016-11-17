module Sidebar exposing (..)

import Html exposing (..)
import Html.Events exposing (..)

type Msg
  = Choose Int

type alias Model =
    { items : List (Int, String)
    , selected : Int
    }

init : Model
init =
    { items = List.map (\x -> (x, "Section " ++ toString x)) [1..10]
    , selected = 0
    }

update : Msg -> Model -> Model
update msg mdl =
    case msg of
        Choose iid -> { mdl | selected = iid }

renderItem : (Int, String) -> Html Msg
renderItem (id, name) =
    li [ onClick (Choose id) ] [
        text name
    ]

view : Model -> Html Msg
view model =
    aside [] (List.map renderItem model.items)