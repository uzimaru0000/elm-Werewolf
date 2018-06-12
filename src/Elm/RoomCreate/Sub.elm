module RoomCreate.Sub exposing (..)

import RoomCreate.Model exposing (..)
import Firebase exposing (..)

subscriptions : Model -> Sub Msg
subscriptions model =
    createRoomSuccess Success