module RoomListing.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Dict exposing (..)
import Json.Decode as JD


type alias Model =
    { roomList : List Room
    , userDict : Dict String User
    , isLoading : Maybe Bool
    }


type Msg
    = ListRequest
    | GetList JD.Value
    | LoadStart ()
    | GetUserList (List User)


init : Model
init =
    { roomList = []
    , userDict = Dict.empty
    , isLoading = Nothing
    }
