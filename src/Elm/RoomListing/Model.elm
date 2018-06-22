module RoomListing.Model exposing (..)

import Room exposing (..)
import Json.Decode as JD


type alias Model =
    { roomList : List Room
    , isLoading : Maybe Bool
    }


type Msg
    = ListRequest
    | GetList JD.Value
    | LoadStart ()


init : Model
init =
    { roomList = []
    , isLoading = Nothing
    }
