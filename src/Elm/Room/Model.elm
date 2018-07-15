module Room.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Json.Decode as JD


type alias Model =
    { room : Room
    , user : User
    }


type Msg
    = Exit
    | FetchRoomInfo JD.Value


init : Room -> User -> Model
init room user =
    Model room user
