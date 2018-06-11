module Model exposing (..)

import User exposing (..)

type alias State =
    { auth : Bool
    }

type alias Model = 
    { user : Maybe User
    , state : State
    }


type Msg
    = NoOp
    | Login
    | Logout
    | LoginSuccess User
    | LogoutSuccess ()
    | AuthStateCheck ()


init : Model
init =
    Model Nothing (State False)