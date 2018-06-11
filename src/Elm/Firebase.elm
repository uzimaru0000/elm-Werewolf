port module Firebase exposing (..)

import User exposing (..)
import Room exposing (..)
import RoomCreate.Model as RoomCreate exposing (..)

port login : () -> Cmd msg
port logout : () -> Cmd msg
port createRoom : RoomCreate.Model -> Cmd msg

port loginSuccess : (User -> msg) -> Sub msg
port logoutSuccess : (() -> msg) -> Sub msg
port authStateCheck : (() -> msg) -> Sub msg
port getRoomList : (List Room -> msg) -> Sub msg