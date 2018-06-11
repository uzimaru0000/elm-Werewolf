module View exposing (..)

import Model exposing (..)
import Auth.View as Auth exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ Auth.view model.authModel |> Html.map AuthMsg
        ]
