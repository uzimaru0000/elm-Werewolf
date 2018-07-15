module Room.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Json.Decode as JD


type alias Model =
    { room : Room
    , user : User
    , isAuth : Bool
    , passwordError : Bool
    , input : String
    }


type Msg
    = Exit
    | FetchRoomInfo JD.Value
    | ModalOff
    | InputPass String
    | Join String


init : Room -> User -> Bool -> Model
init room user isAuth =
    Model room user isAuth False ""
