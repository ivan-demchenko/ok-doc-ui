module Sidebar exposing (..)

import Tree exposing (..)
import Html exposing (..)

type Msg
  = Choose Int
  | Init Tree

type alias Model =
  { selected : Int
  , tree : Tree
  }

init : (Model, Cmd Msg)
init =
  ( Model 0 getSampleTree
  , Cmd.none
  )

update : Msg -> Model -> (Model, Cmd Msg)
update msg mdl =
  case msg of
    Choose iid ->
      ( { mdl | selected = iid }
      , Cmd.none
      )
    Init tree ->
      ( { mdl | tree = tree }
      , Cmd.none
      )

renderTree : Int -> Tree -> Html Msg
renderTree selected tree =
  case tree of
    Tree idx name subs ->
      ul [] [
        li [] (
          [text name] ++ (List.map (renderTree selected) subs))
      ]
    Nil ->
      ul [] []

view : Model -> Html Msg
view { selected, tree } =
  renderTree selected tree