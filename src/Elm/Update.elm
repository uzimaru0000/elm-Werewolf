module Update exposing (..)

import Model exposing (..)
import Routing exposing (Route, parseLocation, routeToUrl)
import Navigation
import Json.Decode as Json
import Dict
import Room exposing (..)
import Firebase exposing (..)
import Auth.Cmd as Auth
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

            Routing.Login ->
                { model | pageState = Loaded Login } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( LocationChange loc, _ ) ->
            setRoute (parseLocation loc) model

        ( RouteChange route, _ ) ->
            model ! [ Navigation.newUrl <| routeToUrl route ]

        ( RoomListingInit initData, _ ) ->
            let
                list =
                    initData.listValue
                        |> Json.decodeValue (Json.list roomDecoder)
                        |> Result.withDefault []

                users =
                    initData.userList
                        |> List.foldl (\x acc -> Dict.insert x.uid x acc) Dict.empty
            in
                { model | pageState = Loaded (RoomListing <| RoomListing.init list users) } ! []

        ( AuthMsg msg, _ ) ->
            (model, Auth.cmd msg)

        _ ->
            model ! []
