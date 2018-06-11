module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (..)
import Update exposing (..)
import Firebase exposing (..)

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
    [ loginSuccess LoginSuccess
    , logoutSuccess LogoutSuccess
    , authStateCheck AuthStateCheck
    ]
    |> Sub.batch