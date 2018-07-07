module Model exposing (..)

import Auth.Model as Auth
import RoomCreate.Model as RoomCreate
import RoomListing.Model as RoomListing
import Routing exposing (..)
import Navigation exposing (Location)
import User exposing (User)
import Firebase exposing (..)


type Page
    = Blank
    | NotFound
    | Login
    | Home
    | RoomCreate RoomCreate.Model
    | RoomListing RoomListing.Model


type PageState
    = Loaded Page
    | Transition Page


type alias Model =
    { pageState : PageState
    , user : Maybe User
    , menuState : Bool
    }


type Msg
    = NoOp
    | LocationChange Location
    | RouteChange Route
    | AuthMsg Auth.Msg
    | RoomCreateMsg RoomCreate.Msg
    | RoomListingMsg RoomListing.Msg
    | RoomListingInit RoomListInitDate
    | Logout
    | LogoutSuccess ()
    | MenuClick


init : Model
init =
    Model
        (Loaded Blank)
        Nothing
        False


getPage : PageState -> Page
getPage state =
    case state of
        Loaded page ->
            page

        Transition page ->
            page


pageToRoute : Page -> Route
pageToRoute page =
    case page of
        RoomCreate _ ->
            Routing.RoomCreate

        RoomListing _ ->
            Routing.RoomListing

        _ ->
            Routing.NotFound
