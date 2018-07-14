module Room.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Json.Decode as JD


type alias Model =
    { room : Room
    , user : User
    , passwordError : Bool
    , isActive : Bool
    , input : String
    }


type Msg
    = Join
    | Exit
    | FetchRoomInfo JD.Value
    | PassWordInput String
    | ModalStateChange Bool


init : Room -> User -> Model
init room user =
    Model room user False False ""
