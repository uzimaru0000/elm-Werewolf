module Update exposing (..)

import Model exposing (..)
import Routing exposing (Route, parseLocation, routeToUrl)
import Navigation
import Json.Decode as Json
import Dict
import Room exposing (..)
import Firebase exposing (..)
import RoomListing.Model as RoomListing
import RoomCreate.Model as RoomCreate


setRoute : Route -> Model -> ( Model, Cmd Msg )
setRoute route model =
    let
        transition cmd =
            ( { model | pageState = Transition <| getPage model.pageState }
            , cmd
            )
    in
        case route of
            Routing.RoomListing ->
                transition <| roomListInit ()

            Routing.RoomCreate ->
                { model | pageState = Loaded (RoomCreate RoomCreate.init) } ! []

            Routing.NotFound ->
                { model | pageState = Loaded NotFound } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LocationChange loc ->
            setRoute (parseLocation loc) model

        RouteChange route ->
            model ! [ Navigation.newUrl <| routeToUrl route ]

        -- AuthMsg msg ->
        --     let
        --         ( auth, cmd ) =
        --             Auth.update msg model.auth
        --     in
        --         ( { model | auth = auth }, Cmd.map AuthMsg cmd )
        -- RoomCreateMsg msg ->
        --     let
        --         ( roomCreate, cmd ) =
        --             RoomCreate.update msg model.roomCreate
        --     in
        --         ( { model | roomCreate = roomCreate }, Cmd.map RoomCreateMsg cmd )
        -- RoomListingMsg msg ->
        --     let
        --         ( roomListing, cmd ) =
        --             RoomListing.update msg
        --     in 
        RoomListingInit initDate ->
            let
                list =
                    initDate.listValue
                        |> Json.decodeValue (Json.list roomDecoder)
                        |> Result.withDefault []

                users =
                    initDate.userList
                        |> List.foldl (\x acc -> Dict.insert x.uid x acc) Dict.empty
            in
                { model | pageState = Loaded (RoomListing <| RoomListing.init list users) } ! []

        _ ->
            model ! []
