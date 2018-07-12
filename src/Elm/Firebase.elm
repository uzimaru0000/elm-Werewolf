port module Firebase exposing (..)

import Json.Encode
import Json.Decode


port login : String -> Cmd msg
port logout : () -> Cmd msg
port createRoom : Json.Encode.Value -> Cmd msg
port listRequest : () -> Cmd msg
port roomListInit : () -> Cmd msg
port roomViewInit : String -> Cmd msg

port logoutSuccess : (() -> msg) -> Sub msg
port getRoomList : (Json.Decode.Value -> msg) -> Sub msg
port createRoomSuccess : (String -> msg) -> Sub msg
port getRoomListDate : (Json.Decode.Value -> msg) -> Sub msg
port getRoomViewData : (Json.Decode.Value -> msg) -> Sub msg