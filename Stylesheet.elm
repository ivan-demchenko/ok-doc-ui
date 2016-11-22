module Stylesheet exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias RuleSet = List (String, String)

type alias Styles = List ( String, RuleSet )  

getStyle : String -> Styles -> Attribute msg
getStyle name stylesheet =
    let
        tmp =
            List.filter (\(styleName, defsList) -> styleName == name) stylesheet
    in
        case tmp of
            ((n, d) :: xs) -> style d
            [] -> style []

stylesheet : Styles
stylesheet =
    [ ("layout",
        [ ("display", "flex")
        ])
    , ("sidebar",
        [ ("display", "flex")
        , ("flex", "0 0 220px")
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
        [ ("padding", "2rem 1rem")
        , ("color", "#fff")
        , ("font-weight", "100")
        , ("font-family", "sans-serif")
        , ("background-color", "#3F51B5")
        ])
    , ("descriptionSection",
        [ ("padding", "1rem 1rem")
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
        [ ("padding", "0 1rem")
        ]
      )
    ]