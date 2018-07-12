module RoomListing.Model exposing (..)

import Room exposing (..)
import Rule exposing (..)


type alias Model =
    { roomList : List Room
    , serchRoomName : Maybe String
    , checkedRules : List Rule
    }


type Msg
    = GetList (List Room)
    | InputRoomName String
    | CheckRule Rule


init : List Room -> Model
init roomList =
    { roomList = roomList
    , serchRoomName = Nothing
    , checkedRules = []
    }
