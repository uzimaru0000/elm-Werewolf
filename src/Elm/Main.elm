module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (..)
import Update exposing (..)
import Auth.Sub as Auth exposing (..)
import RoomCreate.Sub as RoomCreate exposing (..)
import RoomListing.Sub as RoomListing exposing (..)
import Firebase exposing (..)

main : Program Never Model Msg
main =
    program
    { init = init ! [ listRequest () ]
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Auth.subscriptions model.auth |> Sub.map AuthMsg
    , RoomCreate.subscriptions model.roomCreate |> Sub.map RoomCreateMsg
    , RoomListing.subscriptions model.roomListing |> Sub.map RoomListingMsg
    ]
    |> Sub.batch