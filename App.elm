module Main exposing (..)

import Html exposing (..)
import Http as Http
import Tree exposing (..)
import Info as InfoComponent exposing (..)
import Sidebar as SidebarComponent exposing (..)
import Stylesheet exposing (..)

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type Msg
    = Info InfoComponent.Msg
    | Sidebar SidebarComponent.Msg
    | GotInitialData Tree

type alias Model =
    { info: InfoComponent.Model
    , sidebarTree: SidebarComponent.Model
    }

init : (Model, Cmd Msg)
init =
    let
      (infoInit, infoFX) = InfoComponent.init
      (sidebarInit, sidebarFX) = SidebarComponent.init
    in
        ( Model infoInit sidebarInit
        , Cmd.batch
            [ (Cmd.map Info infoFX)
            , Cmd.map Sidebar sidebarFX
            ]
        )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Info x ->
        ( model, Cmd.none )

    Sidebar x ->
        ( model, Cmd.none )

    GotInitialData tree ->
        ( model, Cmd.none)



view : Model -> Html Msg
view model =
    let
        layoutStyle = getStyle "layout" stylesheet 
        sidebarStyle = getStyle "sidebar" stylesheet
        mainStyle = getStyle "main" stylesheet

        sidebarView = SidebarComponent.view model.sidebarTree
        infoView = (InfoComponent.view stylesheet) model.info
    in
        div [ layoutStyle ]
            [ div [ sidebarStyle ] [ Html.map Sidebar sidebarView ]
            , div [ mainStyle ] [ Html.map Info infoView ]
            ]