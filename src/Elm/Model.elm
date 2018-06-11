module Model exposing (..)

import User exposing (..)
import Auth.Model as Auth

type alias Model = 
    { authModel : Auth.Model
    }


type Msg
    = NoOp
    | AuthMsg Auth.Msg


init : Model
init =
    Model Auth.init