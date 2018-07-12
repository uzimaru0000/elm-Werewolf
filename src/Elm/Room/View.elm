module Room.View exposing (..)

import Html exposing (Html, text, span, div, a)
import Room.Model exposing (..)
import Bulma.Layout exposing (..)
import Bulma.Elements exposing (..)


view : Model -> Html msg
view { room } =
    section NotSpaced
        []
        [ container []
            [ title H1 [] [ text room.name ]
            , subtitle H5 [] [ text <| String.join " : " [ "Owner", room.owner.name ] ]
            ]
        ]