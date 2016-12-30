module Sidebar exposing (..)



import Tree exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Stylesheet exposing (..)



type alias Path =
  String

type Msg
  = Choose Path


type alias Model =
  { selected : Path
  , tree : Tree
  }



init : (Model, Cmd Msg)
init =
  ( Model "" empty
  , Cmd.none
  )



update : Msg -> Model -> (Model, Cmd Msg)
update msg mdl =
  case msg of
    Choose nodePath ->
      ( { mdl | selected = nodePath }
      , Cmd.none
      )


renderTreeLabel : Path -> Path -> String -> Html Msg
renderTreeLabel selectedPath nodePath name =
  if selectedPath == nodePath
    then (strong [] [ text name ])
    else (span [] [ text name ])



renderTree : Styles -> Path -> Tree -> Html Msg
renderTree styles selectedPath tree =
  case tree of
    { name, path, subs } ->
      ul [ getStyle "tree" styles ] [
        li [ clicked path ] (
          [ renderTreeLabel selectedPath path name ] ++ renderSubTree styles selectedPath subs
        )
      ]



clicked : Path -> Attribute Msg
clicked nodePath =
  onWithOptions "click" (Options True True) (succeed <| Choose nodePath)



renderSubTree : Styles -> Path -> Subs -> List (Html Msg)
renderSubTree styles selectedPath subs =
  case subs of
    Subs xs -> List.map (renderTree styles selectedPath) xs



view : Styles -> Model -> Html Msg
view stylesheet { selected, tree } =
  renderTree stylesheet selected tree
