module Auth.Model exposing (..)

import User exposing (..)

type alias Model =
    { user : Maybe User
    , state : Bool
    }


type Msg
    = Login
    | Logout
    | LoginSuccess User
    | LogoutSuccess ()
    | AuthStateCheck ()


init : Model
init =
    Model Nothing False