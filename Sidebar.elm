module Sidebar exposing (..)



import Tree exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Stylesheet exposing (..)



type Msg
  = Choose Int

type alias Model =
  { selected : Int
  , tree : Tree
  }



init : (Model, Cmd Msg)
init =
  ( Model 0 empty
  , Cmd.none
  )



update : Msg -> Model -> (Model, Cmd Msg)
update msg mdl =
  case msg of
    Choose iid ->
      ( { mdl | selected = iid }
      , Cmd.none
      )


renderTreeLabel : Int -> Int -> String -> Html Msg
renderTreeLabel selected idx name =
  if selected == idx
    then (strong [] [ text name ])
    else (span [] [ text name ])



renderTree : Styles -> Int -> Tree -> Html Msg
renderTree styles selected tree =
  case tree of
    { idx, name, subs } ->
      ul [ getStyle "tree" styles ] [
        li [ clicked idx ] ([
          renderTreeLabel selected idx name
        ] ++ renderSubTree styles selected subs)
      ]



clicked : Int -> Attribute Msg
clicked idx =
  onWithOptions "click" (Options True True) (succeed (Choose idx))



renderSubTree : Styles -> Int -> Subs -> List (Html Msg)
renderSubTree styles selected subs =
  case subs of
    Subs xs -> List.map (renderTree styles selected) xs



view : Styles -> Model -> Html Msg
view stylesheet { selected, tree } =
  renderTree stylesheet selected tree
