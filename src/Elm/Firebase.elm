port module Firebase exposing (..)

import User exposing (..)

port login : () -> Cmd msg
port logout : () -> Cmd msg

port loginSuccess : (User -> msg) -> Sub msg
port logoutSuccess : (() -> msg) -> Sub msg