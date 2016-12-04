module Main exposing (..)

import Html exposing (..)
import Tree as T
import Http as Http
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
    | FromSidebar SidebarComponent.Msg
    | GotTree (Result Http.Error T.Tree)
    | GotInfo (Result Http.Error InfoComponent.Info)
    | Noop

type alias Model =
    { info: InfoComponent.Model
    , sidebar: SidebarComponent.Model
    , err: String
    }



init : (Model, Cmd Msg)
init =
    let
      (infoInit, infoFX) = InfoComponent.init
      (sidebarInit, sidebarFX) = SidebarComponent.init
    in
        ( Model infoInit sidebarInit "np"
        , Cmd.batch
            [ Cmd.map Info infoFX
            , Cmd.map FromSidebar sidebarFX
            , getJsonTree
            ]
        )

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Info x ->
        ( model
        , Cmd.map (\_ -> Noop) Cmd.none
        )

    FromSidebar sbMsg ->
        let
            (sbModel, sbCmd) = SidebarComponent.update sbMsg model.sidebar
        in
            ( { model | sidebar = sbModel }
            , fetchInfo sbModel.selected)

    GotInfo (Ok info) ->
        ( { model | info = (InfoComponent.filledModel info) }
        , Cmd.none
        )

    GotInfo (Err problem) ->
        handleHttpError problem model

    GotTree (Ok tree) ->
        ( { model | sidebar = SidebarComponent.Model 0 tree }
        , Cmd.none
        )

    GotTree (Err problem) ->
        handleHttpError problem model

    Noop ->
        ( model
        , Cmd.none
        )


-- Data / HTTP

handleHttpError : Http.Error -> Model -> (Model, Cmd Msg)
handleHttpError problem model =
    case problem of
        Http.BadPayload reason resp ->
            ( { model | err = (toString reason) }
            , Cmd.none
            )
        _ ->
            ( model
            , Cmd.none
            )

fetchInfo : Int -> Cmd Msg
fetchInfo idx =
    let
        url = "https://runkit.io/raqystyle/express-test/branches/master/sections/" ++ (toString idx)
    in
        Http.send GotInfo <| Http.get url InfoComponent.decodeInfo

getJsonTree : Cmd Msg
getJsonTree =
    let
        url = "https://runkit.io/raqystyle/express-test/branches/master/sections"
    in
        Http.send GotTree <| Http.get url T.decodeTree


-- View

view : Model -> Html Msg
view model =
    let
        main_Style = getStyle "main_" stylesheet
        layoutStyle = getStyle "layout" stylesheet
        sidebarStyle = getStyle "sidebar" stylesheet
        mainStyle = getStyle "main" stylesheet

        sidebarView = (SidebarComponent.view stylesheet) model.sidebar
        infoView = (InfoComponent.view stylesheet) model.info
    in
        main_ [ main_Style ] [
            div [ layoutStyle ]
                [ div [] [ text model.err ]
                , div [ sidebarStyle ] [ Html.map FromSidebar sidebarView ]
                , div [ mainStyle ] [ Html.map Info infoView ]
                ]
            ]
