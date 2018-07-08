module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html msg
view =
    div
        [ class "container" ]
        [ div
            [ class "title" ]
            [ text "This is home." ]
        ]