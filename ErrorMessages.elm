module ErrorMessages exposing (Msg, Model, Error, IndexedModel, view, update)



import Html exposing (..)
import Html.Events exposing (..)
import Stylesheet exposing (..)



type Msg = Close Int



type alias Error =
  { errorType: String
  , message: String
  }



type alias IndexedModel =
  (Int, Error)



type alias Model =
  List IndexedModel



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Close idx ->
      ( List.filter (\(errIdx, _) -> errIdx /= idx) model
      , Cmd.none
      )



renderErrorMsg : Styles -> IndexedModel -> Html Msg
renderErrorMsg stylesheet (idx, {errorType, message}) =
  div [getStyle "error" stylesheet]
    [ button [ onClick (Close idx) ] [ text "Dismiss" ]
    , strong [] [ text errorType ]
    , text message
    ]


view : Styles -> Model -> Html Msg
view stylesheet model =
  div [getStyle "errors" stylesheet] (List.map (renderErrorMsg stylesheet) model)
