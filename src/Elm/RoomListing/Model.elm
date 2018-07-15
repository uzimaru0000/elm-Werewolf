module RoomListing.Model exposing (..)

import Room exposing (..)


type alias Model =
    { roomList : List Room
    , selectedRoom : Maybe Room
    , input : String
    , passwordError : Bool
    }


type Msg
    = GetList (List Room)
    | Join String
    | SelectRoom Room
    | InputPass String
    | ModalOff


init : List Room -> Model
init roomList =
    { roomList = roomList
    , selectedRoom = Nothing
    , input = ""
    , passwordError = False
    }
