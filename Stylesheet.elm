module Stylesheet exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias RuleSet = List (String, String)

type alias Styles = List ( String, RuleSet )

getStyle : String -> Styles -> Attribute msg
getStyle query stylesheet =
    let
        tmp =
            List.filter (\(name, _) -> name == query) stylesheet
    in
        case tmp of
            ((n, d) :: xs) -> style d
            [] -> style []

stylesheet : Styles
stylesheet =
    [ ("main_",
        [ ("display", "flex")
        , ("flex-direction", "column")
        , ("height", "100%")
        , ("font-family", "sans-serif")
        ])
    , ("layout",
        [ ("display", "flex")
        , ("flex", "1")
        ])
    , ("sidebar",
        [ ("display", "flex")
        , ("flex", "0 0 220px")
        , ("background-color", "#37474F")
        , ("color", "#CFD8DC")
        , ("padding", "1rem 0")
        , ("overflow", "auto")
        ])
    , ("errors",
        [ ("display", "flex")
        , ("flex-direction", "column")
        , ("background-color", "#ef5350")
        , ("color", "#ffebee")
        , ("position", "absolute")
        , ("width", "100%")
        ])
    , ("error",
        [ ("padding", "1rem")
        ])
    , ("tree",
        [ ("list-style", "none")
        , ("padding", "0 0 0 1rem")
        , ("margin", "0")
        ])
    , ("main",
        [ ("display", "flex")
        , ("flex", "1 0 auto")
        ])
    , ("infoSection",
        [ ("display", "flex")
        , ("flex-direction", "column")
        , ("flex", "1 0 auto")
        ])
    , ("emptyInfo",
        [ ("padding", "3rem 0")
        , ("text-align", "center")
        , ("background-color", "#f4f4f4")
        , ("flex", "1 0 auto")
        ])
    , ("titleSection",
        [ ("padding", "1rem")
        , ("color", "#fff")
        , ("font-weight", "100")
        , ("font-family", "sans-serif")
        , ("background-color", "#3F51B5")
        ])
    , ("descriptionSection",
        [ ("padding", "0 1rem")
        , ("font-weight", "100")
        , ("font-family", "sans-serif")
        , ("background-color", "#BBDEFB")
        ])
    , ("demoLinksSection",
        [ ("background-color", "#E3F2FD")
        , ("padding", "1rem 1rem")
        ]
      )
    , ("demoLinksList",
        [ ("list-style", "none")
        , ("padding", "0")
        , ("margin", "0")
        , ("display", "flex")
        ]
      )
    , ("demoLinksListItem",
        [ ("padding", "0 .5rem")
        ]
      )
    , ("demoLinksListItemSelected",
        [ ("padding", "0 .5rem")
        , ("font-weight", "bold")
        ]
      )
    , ("demoViewer",
        [ ("border", "none")
        , ("flex", "1")
        ]
      )
    ]
