module RoomListing.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Rule exposing (..)
import Dict exposing (..)
import Json.Decode as JD
import Firebase exposing (..)


type alias Model =
    { roomList : List Room
    , userDict : Dict String User
    , isLoading : Maybe Bool
    , serchRoomName : Maybe String
    , checkedRules : List Rule
    }


type Msg
    = ListRequest
    | GetList (List Room)
    | LoadStart ()
    | GetUserList (List User)
    | InputRoomName String
    | CheckRule Rule


init : List Room -> Dict String User -> Model
init roomList userDict =
    { roomList = roomList
    , userDict = userDict
    , isLoading = Nothing
    , serchRoomName = Nothing
    , checkedRules = []
    }
