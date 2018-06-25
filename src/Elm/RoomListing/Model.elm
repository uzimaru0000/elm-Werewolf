module RoomListing.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Rule exposing (..)
import Dict exposing (..)
import Json.Decode as JD


type alias Model =
    { roomList : List Room
    , userDict : Dict String User
    , isLoading : Maybe Bool
    , serchRoomName : Maybe String
    , checkedRules : List Rule
    }


type Msg
    = ListRequest
    | GetList JD.Value
    | LoadStart ()
    | GetUserList (List User)
    | InputRoomName String
    | CheckRule Rule


init : Model
init =
    { roomList = []
    , userDict = Dict.empty
    , isLoading = Nothing
    , serchRoomName = Nothing
    , checkedRules = []
    }
