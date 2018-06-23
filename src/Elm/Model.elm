module Model exposing (..)

import Auth.Model as Auth
import RoomCreate.Model as RoomCreate
import RoomListing.Model as RoomListing
import Routing exposing (..)
import Navigation exposing (Location)


type alias Model =
    { auth : Auth.Model
    , roomCreate : RoomCreate.Model
    , roomListing : RoomListing.Model
    , route : Route
    }


type Msg
    = NoOp
    | LocationChange Location
    | AuthMsg Auth.Msg
    | RoomCreateMsg RoomCreate.Msg
    | RoomListingMsg RoomListing.Msg
    | RouteChange Route


init : Model
init =
    Model
        Auth.init
        RoomCreate.init
        RoomListing.init
        RoomListing
