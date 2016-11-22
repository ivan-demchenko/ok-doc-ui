module Sidebar exposing (..)



import Tree exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)



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

renderTree : Int -> Tree -> Html Msg
renderTree selected tree =
  case tree of
    { idx, name, subs } ->
      ul [] [
        li [ clicked idx ] ([
          renderTreeLabel selected idx name
        ] ++ renderSubTree selected subs)
      ]


clicked : Int -> Attribute Msg
clicked idx =
  onWithOptions "click" (Options True True) (succeed (Choose idx))

renderSubTree : Int -> Subs -> List (Html Msg)
renderSubTree selected subs =
  case subs of
    Subs xs -> List.map (renderTree selected) xs 



view : Model -> Html Msg
view { selected, tree } =
  renderTree selected tree