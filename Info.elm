module Info exposing (Msg, Info, Model, init, view, decodeInfo, filledModel)

import Html exposing (..)
import Stylesheet exposing (..)
import Json.Decode exposing (..)



type Msg = Noop

type alias DemoModel =
  { name: String
  , path: String
  }

type alias Info = 
  { title: String
  , descr: String
  , demos: List DemoModel
  }

type Model = Full Info | None


filledModel : Info -> Model
filledModel =
  Full


init : (Model, Cmd Msg)
init =
  (None, Cmd.none)



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop -> (model, Cmd.none)



renderDemoLink : Styles -> DemoModel -> Html Msg
renderDemoLink styles demo =
  li [ getStyle "demoLinksListItem" styles ] [
    text demo.name
  ]



renderInfo : Styles -> Model -> Html Msg
renderInfo stylesheet model =
  case model of
    None ->
      let
        emptyInfo = getStyle "emptyInfo" stylesheet
      in
        div [ emptyInfo ] [ text "Please, select something on the right" ]

    Full {title, descr, demos} ->
      let
        sectionStyle = getStyle "infoSection" stylesheet
        titleStyle = getStyle "titleSection" stylesheet
        descrStyle = getStyle "descriptionSection" stylesheet
        demoLinksStyle = getStyle "demoLinksSection" stylesheet
        demoLinksListStyle = getStyle "demoLinksList" stylesheet
      in   
        div [ sectionStyle ] [
          section [ titleStyle ] [
            h1 [] [text title]
          ],
          section [ descrStyle ] [text descr],
          section [ demoLinksStyle ] [
              ul [ demoLinksListStyle ] (List.map (renderDemoLink stylesheet) demos)
          ]
        ]



view : Styles -> Model -> Html Msg
view = renderInfo



decodeDemoModel : Decoder DemoModel
decodeDemoModel =
  map2 DemoModel
    (field "name" string)
    (field "path" string)


decodeInfo : Decoder Info
decodeInfo =
  map3 Info
    (field "title" string)
    (field "descr" string)
    (field "demos" (list decodeDemoModel))