module Model exposing (..)

import User exposing (..)

type alias Model = 
    { user : Maybe User
    }


type Msg
    = NoOp
    | Login
    | Logout
    | LoginSuccess User
    | LogoutSuccess ()


init : Model
init =
    Model Nothing