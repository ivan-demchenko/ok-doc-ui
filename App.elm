import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)

main : Program Never
main =
  Html.App.beginnerProgram { model = init, view = (view stylesheet), update = update }

type Msg =
  Noop 

type alias DemoModel =
  { name: String
  , link: String
  }

type alias Model =
  { title: String
  , descr: String
  , demos: List DemoModel
  }

init : Model
init =
  Model "A Component" "Some great stuff here" [
    (DemoModel "Demo 1" "http://ex.com/demo1.html"),
    (DemoModel "Demo 2" "http://ex.com/demo2.html"),
    (DemoModel "Demo 3" "http://ex.com/demo3.html")
  ]

stylesheet : List ( String, List ( String, String ) )
stylesheet =
    [ ("titleSection",
        [ ("padding", "2rem .7rem")
        , ("color", "#fff")
        , ("font-weight", "100")
        , ("font-family", "sans-serif")
        , ("background-color", "#3F51B5")
        ])
    , ("descriptionSection",
        [ ("padding", "1rem .7rem")
        , ("font-weight", "100")
        , ("font-family", "sans-serif")
        , ("background-color", "#BBDEFB")
        ])
    , ("demoLinksSection",
        [ ("background-color", "#E3F2FD")
        , ("padding", "1rem .7rem")
        ]
      )
    , ("demoLinksList",
        [ ("list-style", "none")
        , ("padding", "0")
        , ("margin", "0")
        , ("display", "flex")
        ]
      )
    , ("demoLinksListItem", [
        ("padding", "0 1rem")
        ]
      )
    ]

getStyle : String -> List ( String, List ( String, String ) ) -> Attribute msg
getStyle name stylesheet =
    let tmp = List.filter (\(styleName, defsList) -> styleName == name) stylesheet
    in
        case tmp of
            ((n, d) :: xs) -> style d
            [] -> style []

renderDemoLink : List ( String, List ( String, String ) ) -> DemoModel -> Html Msg
renderDemoLink styles {name, link} =
  li [ getStyle "demoLinksListItem" styles ] [
    a [href link] [text name]
  ]

view : List ( String, List ( String, String ) ) -> Model -> Html Msg
view stylesheet {title, descr, demos} =
  div [] [
    section [ (getStyle "titleSection" stylesheet) ] [
      h1 [] [text title]
    ],
    section [ (getStyle "descriptionSection" stylesheet) ] [text descr],
    section [ (getStyle "demoLinksSection" stylesheet) ] [
        ul [ (getStyle "demoLinksList" stylesheet) ] (List.map (renderDemoLink stylesheet) demos)
    ]
  ]


update : Msg -> Model -> Model
update msg model =
  case msg of
    Noop -> model
