port module Firebase exposing (..)

import User exposing (..)
import Json.Encode
import Json.Decode


type alias RoomListInitDate =
    { listValue : Json.Decode.Value
    , userList : List User
    }
    

port login : () -> Cmd msg
port logout : () -> Cmd msg
port createRoom : Json.Encode.Value -> Cmd msg
port listRequest : () -> Cmd msg
port usersRequest : () -> Cmd msg

port roomListInit : () -> Cmd msg

port loginSuccess : (User -> msg) -> Sub msg
port logoutSuccess : (() -> msg) -> Sub msg
port authStateCheck : (() -> msg) -> Sub msg
port getRoomList : (Json.Decode.Value -> msg) -> Sub msg
port createRoomSuccess : (() -> msg) -> Sub msg
port loadingStart : (() -> msg) -> Sub msg
port getUsers : (List User -> msg) -> Sub msg

port getRoomListDate : (RoomListInitDate -> msg) -> Sub msg