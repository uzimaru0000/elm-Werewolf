module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (..)
import Update exposing (..)
import Auth.Sub as Auth exposing (..)

main : Program Never Model Msg
main =
    program
    { init = init ! []
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Auth.subscriptions model.authModel |> Sub.map AuthMsg
    ]
    |> Sub.batch