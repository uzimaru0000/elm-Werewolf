module Model exposing (..)


import Auth.Model as Auth
import RoomCreate.Model as RoomCreate

type alias Model = 
    { auth : Auth.Model
    , roomCreate : RoomCreate.Model
    }


type Msg
    = NoOp
    | AuthMsg Auth.Msg
    | RoomCreateMsg RoomCreate.Msg


init : Model
init =
    Model Auth.init RoomCreate.init