module Model exposing (..)


import Auth.Model as Auth
import RoomCreate.Model as RoomCreate
import RoomListing.Model as RoomListing

type alias Model = 
    { auth : Auth.Model
    , roomCreate : RoomCreate.Model
    , roomListing : RoomListing.Model
    }


type Msg
    = NoOp
    | AuthMsg Auth.Msg
    | RoomCreateMsg RoomCreate.Msg
    | RoomListingMsg RoomListing.Msg


init : Model
init =
    Model
        Auth.init
        RoomCreate.init
        RoomListing.init