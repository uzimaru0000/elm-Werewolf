module Update exposing (..)

import Model exposing (..)
import Routing exposing (..)
import Navigation
import Auth.Update as Auth exposing (..)
import RoomCreate.Update as RoomCreate exposing (..)
import RoomListing.Update as RoomListing exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LocationChange loc ->
            let
                newRoute =
                    parseLocation loc
            in
                if model.auth.user /= Nothing then
                    { model | route = newRoute } ! []
                else
                    { model | route = Login } ! []

        RouteChange route ->
            model ! [ Navigation.newUrl <| routeToUrl route ]

        AuthMsg msg ->
            let
                ( auth, cmd ) =
                    Auth.update msg model.auth
            in
                ( { model | auth = auth }, Cmd.map AuthMsg cmd )

        RoomCreateMsg msg ->
            let
                ( roomCreate, cmd ) =
                    RoomCreate.update msg model.roomCreate
            in
                ( { model | roomCreate = roomCreate }, Cmd.map RoomCreateMsg cmd )

        RoomListingMsg msg ->
            let
                ( roomListing, cmd ) =
                    RoomListing.update msg model.roomListing
            in
                ( { model | roomListing = roomListing }, Cmd.map RoomListingMsg cmd )

        _ ->
            model ! []
