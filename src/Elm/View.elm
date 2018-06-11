module View exposing (..)

import Model exposing (..)
import Auth.View as Auth exposing (..)
import RoomCreate.View as RoomCreate exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ Auth.view model.auth |> Html.map AuthMsg
        , div [ class "container" ]
            []
        , RoomCreate.view model.roomCreate |> Html.map RoomCreateMsg
        ]
