module Info exposing (Msg, Info, Model, init, view, decodeInfo, filledModel)

import Html exposing (..)
import Markdown as Markdown exposing (..)
import Stylesheet exposing (..)
import Json.Decode exposing (..)



type Msg = Noop

type alias DemoModel =
  { name: String
  , path: String
  }

type alias Info =
  { name: String
  , descr: String
  , demos: Maybe (List DemoModel)
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


renderDemos : Styles -> Maybe (List DemoModel) -> Html Msg
renderDemos stylesheet demos =
  let
    demoLinksStyle =
      getStyle "demoLinksSection" stylesheet
    demoLinksListStyle =
      getStyle "demoLinksList" stylesheet
  in
    case demos of
      Just xs ->
        section [ demoLinksStyle ] [
          ul [ demoLinksListStyle ] (List.map (renderDemoLink stylesheet) xs)
        ]
      Nothing ->
        section [] []


renderInfo : Styles -> Model -> Html Msg
renderInfo stylesheet model =
  case model of
    None ->
      let
        emptyInfo = getStyle "emptyInfo" stylesheet
      in
        div [ emptyInfo ] [ text "Please, select something on the right" ]

    Full {name, descr, demos} ->
      let
        sectionStyle = getStyle "infoSection" stylesheet
        titleStyle = getStyle "titleSection" stylesheet
        descrStyle = getStyle "descriptionSection" stylesheet
      in
        div [ sectionStyle ] [
          section [ titleStyle ] [
            h1 [] [text name]
          ],
          (Markdown.toHtml [ descrStyle ] descr),
          (renderDemos stylesheet demos)
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
    (field "name" string)
    (field "descr" string)
    (maybe (field "demos" (list decodeDemoModel)))
