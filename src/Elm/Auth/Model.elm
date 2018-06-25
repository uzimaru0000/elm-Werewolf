module Auth.Model exposing (..)

import User exposing (..)


type alias Model =
    { user : Maybe User
    , state : Bool
    , menuClick : Bool
    }


type LoginType
    = Twitter


type Msg
    = Login LoginType
    | Logout
    | LoginSuccess User
    | MenuClick
    | LogoutSuccess ()
    | AuthStateCheck ()


init : Model
init =
    Model Nothing False False