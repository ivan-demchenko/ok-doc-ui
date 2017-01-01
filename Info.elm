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



renderDemoLink : Styles -> Maybe String -> DemoModel -> Html Msg
renderDemoLink styles selectedPath demo =
  let
    styleName = 
      case selectedPath of
        Just path ->
          if demo.path == path then "demoLinksListItemSelected" else "demoLinksListItem"
        Nothing ->
          "demoLinksListItem"
  in
    li [
      getStyle styleName styles,
      onClick (SelectDemo demo.path)
    ] [ text demo.name ]


renderDemos : Styles -> Maybe String -> Maybe (List DemoModel) -> Html Msg
renderDemos stylesheet selectedDemo demos =
  let
    demoLinksStyle =
      getStyle "demoLinksSection" stylesheet
    demoLinksListStyle =
      getStyle "demoLinksList" stylesheet
  in
    case demos of
      Just xs ->
        section [ demoLinksStyle ] [
          ul [ demoLinksListStyle ] (List.map (renderDemoLink stylesheet selectedDemo) xs)
        ]
      Nothing ->
        section [] []


renderSelectedDemo : Styles -> Maybe String -> Html Msg
renderSelectedDemo stylesheet demoPath =
  case demoPath of
    Just path ->
      let
        demoViewerStyle = getStyle "demoViewer" stylesheet
        demoPath = "http://localhost:3000/demo?path=" ++ path
      in
        iframe [
          demoViewerStyle,
          src demoPath
        ] []

    Nothing ->
      div [] []

renderInfo : Styles -> Model -> Html Msg
renderInfo stylesheet model =
  case model of
    None ->
      div
        [ getStyle "emptyInfo" stylesheet ]
        [ text "Please, select something on the right" ]

    Full {name, descr, demos, selectedDemoPath} ->
      let
        sectionStyle = getStyle "infoSection" stylesheet
        titleStyle = getStyle "titleSection" stylesheet
        descrStyle = getStyle "descriptionSection" stylesheet
      in
        div
          [ sectionStyle ]
          [ section
            [ titleStyle ]
            [ h1 [] [text name] ],
          (Markdown.toHtml [ descrStyle ] descr),
          (renderDemos stylesheet selectedDemoPath demos),
          (renderSelectedDemo stylesheet selectedDemoPath)
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
