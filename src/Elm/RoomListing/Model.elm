module RoomListing.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Rule exposing (..)
import Dict exposing (..)


type alias Model =
    { roomList : List Room
    , userDict : Dict String User
    , serchRoomName : Maybe String
    , checkedRules : List Rule
    }


type Msg
    = GetList (List Room)
    | GetUserList (List User)
    | InputRoomName String
    | CheckRule Rule


init : List Room -> Dict String User -> Model
init roomList userDict =
    { roomList = roomList
    , userDict = userDict
    , serchRoomName = Nothing
    , checkedRules = []
    }
