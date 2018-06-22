port module Firebase exposing (..)

import User exposing (..)
import Json.Encode
import Json.Decode

port login : () -> Cmd msg
port logout : () -> Cmd msg
port createRoom : Json.Encode.Value -> Cmd msg
port listRequest : () -> Cmd msg
port userRequest : String -> Cmd msg

port loginSuccess : (User -> msg) -> Sub msg
port logoutSuccess : (() -> msg) -> Sub msg
port authStateCheck : (() -> msg) -> Sub msg
port getRoomList : (Json.Decode.Value -> msg) -> Sub msg
port createRoomSuccess : (() -> msg) -> Sub msg
port loadingStart : (() -> msg) -> Sub msg
port getUser : (User -> msg) -> Sub msg