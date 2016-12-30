module Info exposing (Msg, Info, Model, update, init, view, decodeInfo, filledModel)

import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Markdown as Markdown exposing (..)
import Stylesheet exposing (..)
import Json.Decode exposing (..)



type Msg
  = Noop
  | SelectDemo String

type alias DemoModel =
  { name: String
  , path: String
  }

type alias Info =
  { name: String
  , descr: String
  , demos: Maybe (List DemoModel)
  , selectedDemoPath: Maybe String
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
    Noop ->
      ( model
      , Cmd.none
      )
    
    SelectDemo demoPath ->
      case model of
        None ->
          (model, Cmd.none)
        
        Full oldInfo ->
          let
            newInfo =
              { oldInfo | selectedDemoPath = Just demoPath }
          in
            (filledModel newInfo, Cmd.none)



renderDemoLink : Styles -> DemoModel -> Html Msg
renderDemoLink styles demo =
  li [
    getStyle "demoLinksListItem" styles,
    onClick (SelectDemo demo.path)
  ] [ text demo.name ]


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


renderSelectedDemo : Maybe String -> Html Msg
renderSelectedDemo demoPath =
  case demoPath of
    Just path ->
      let
        demoPath = "http://localhost:3000/demo?path=" ++ path
      in
        iframe [src demoPath] []
    
    Nothing ->
      div [] []

renderInfo : Styles -> Model -> Html Msg
renderInfo stylesheet model =
  case model of
    None ->
      let
        emptyInfo = getStyle "emptyInfo" stylesheet
      in
        div [ emptyInfo ] [ text "Please, select something on the right" ]

    Full {name, descr, demos, selectedDemoPath} ->
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
          (renderDemos stylesheet demos),
          (renderSelectedDemo selectedDemoPath)
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
  map4 Info
    (field "name" string)
    (field "descr" string)
    (maybe (field "demos" (list decodeDemoModel)))
    (maybe (field "selectedDemoPath" string))
