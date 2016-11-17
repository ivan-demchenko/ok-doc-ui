module Main exposing (..)

import Html.App
import Html exposing (..)
import Info as InfoComponent
import Sidebar as SidebarComponent
import Stylesheet exposing (..)

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type Msg
    = Info InfoComponent.Msg
    | Sidebar SidebarComponent.Msg

type alias Model =
    { info: InfoComponent.Model
    , sidebar: SidebarComponent.Model
    }

init : (Model, Cmd msg)
init =
    ({ info = InfoComponent.init
    ,  sidebar = SidebarComponent.init
    }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Info x -> (model, Cmd.none)
    Sidebar x -> (model, Cmd.none)


view : Model -> Html Msg
view model =
    let
        layoutStyle = getStyle "layout" stylesheet 
        sidebarStyle = getStyle "sidebar" stylesheet
        mainStyle = getStyle "main" stylesheet

        sidebarView = SidebarComponent.view model.sidebar
        infoView = (InfoComponent.view stylesheet) model.info
    in
        div [ layoutStyle ]
            [ div [ sidebarStyle ] [ Html.App.map Sidebar sidebarView ]
            , div [ mainStyle ] [ Html.App.map Info infoView ]
            ]