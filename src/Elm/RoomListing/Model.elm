module RoomListing.Model exposing (..)

import Room exposing (..)


type alias Model =
    { roomList : List Room
    , isLoading : Maybe Bool
    }


type Msg
    = ListRequest
    | GetList (List Room)
    | LoadStart ()


init : Model
init =
    { roomList = []
    , isLoading = Nothing
    }
