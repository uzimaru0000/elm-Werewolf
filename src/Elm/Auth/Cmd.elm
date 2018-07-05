module Auth.Cmd exposing (..)

import Auth.Model exposing (..)
import Firebase exposing (..)


cmd : Msg -> Cmd msg
cmd msg =
    case msg of
        Login loginType ->
            login <| toString loginType

        Logout ->
            logout ()
