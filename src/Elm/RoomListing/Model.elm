module RoomListing.Model exposing (..)

import Room exposing (..)
import User exposing (..)
import Dict exposing (..)


type alias Model =
    { roomList : List Room
    , userDict : Dict String User
    , isLoading : Maybe Bool
    }


type Msg
    = ListRequest
    | GetList (List Room)
    | LoadStart ()
    | GetUserList (List User)


init : Model
init =
    { roomList = []
    , userDict = Dict.empty
    , isLoading = Nothing
    }
