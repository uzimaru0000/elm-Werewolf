module Room.View exposing (..)

import Html exposing (Html)
import Room exposing (..)
import Room.Model exposing (..)
import Bulma.Layout exposing (..)


view : Model -> Html msg
view { room } =
    section NotSpaced
        []
        [ container []
            []
        ]