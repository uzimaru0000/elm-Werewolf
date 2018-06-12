module RoomListing.Sub exposing (..)

import RoomListing.Model exposing (..)
import Firebase exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    [ getRoomList GetList
    , loadingStart LoadStart
    ]
        |> Sub.batch
