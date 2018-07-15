module Update exposing (..)

import Model exposing (..)
import Routing exposing (Route, parseLocation, routeToUrl)
import Navigation
import Json.Decode as Json
import Room exposing (..)
import Firebase exposing (..)
import Auth.Cmd as Auth
import RoomListing.Model as RoomListing
import RoomListing.Update as RoomListing
import RoomCreate.Model as RoomCreate
import RoomCreate.Update as RoomCreate
import Room.Model as Room
import Room.Update as Room


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
                if model.user /= Nothing then
                    transition <| roomListInit ()
                else
                    { model | pageState = Loaded Home } ! []

            Routing.RoomCreate ->
                { model | pageState = Loaded (RoomCreate RoomCreate.init) } ! []

            Routing.NotFound ->
                { model | pageState = Loaded NotFound } ! []

            Routing.Login ->
                { model | pageState = Loaded Login } ! []

            Routing.Room uid ->
                transition <| roomViewInit uid


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( msg, page ) of
        ( LocationChange loc, RoomView subModel ) ->
            let
                ( newModel, cmd ) =
                    setRoute (parseLocation loc) model
            in
                newModel ! [ cmd, exitRoom <| roomEncoder subModel.room ]

        ( LocationChange loc, _ ) ->
            setRoute (parseLocation loc) model

        ( RouteChange route, _ ) ->
            model ! [ Navigation.newUrl <| routeToUrl route ]

        ( RoomListingInit initData, _ ) ->
            let
                list =
                    initData
                        |> Json.decodeValue (Json.list roomDecoder)
                        |> Result.withDefault []
            in
                { model | pageState = Loaded (RoomListing <| RoomListing.init list) } ! []

        ( RoomViewInit initData, _ ) ->
            let
                maybeRoom =
                    initData
                        |> Json.decodeValue roomDecoder
                        |> Result.toMaybe
            in
                case ( maybeRoom, model.user ) of
                    ( Just room, Just user ) ->
                        { model | pageState = Loaded (RoomView <| Room.init room user) }
                            ! [ if not <| List.member user room.member then
                                    Navigation.newUrl <| Routing.routeToUrl Routing.RoomListing
                                else
                                    Cmd.none
                              ]

                    ( Nothing, _ ) ->
                        { model | pageState = Loaded NotFound } ! []

                    _ ->
                        model ! [ Navigation.newUrl <| Routing.routeToUrl Routing.RoomListing ]

        ( RoomListingMsg subMsg, RoomListing oldModel ) ->
            let
                ( subModel, subCmd ) =
                    RoomListing.update subMsg oldModel
            in
                { model | pageState = Loaded (RoomListing subModel) } ! [ Cmd.map RoomListingMsg subCmd ]

        ( RoomCreateMsg subMsg, RoomCreate oldModel ) ->
            let
                ( subModel, subCmd ) =
                    RoomCreate.update subMsg oldModel
            in
                { model | pageState = Loaded (RoomCreate subModel) } ! [ Cmd.map RoomCreateMsg subCmd ]

        ( RoomMsg subMsg, RoomView oldModel ) ->
            let
                ( subModel, subCmd ) =
                    Room.update subMsg oldModel
            in
                { model | pageState = Loaded (RoomView subModel) } ! [ Cmd.map RoomMsg subCmd ]

        ( AuthMsg msg, _ ) ->
            ( model, Auth.cmd msg )

        ( Logout, _ ) ->
            model ! [ logout () ]

        ( LogoutSuccess _, _ ) ->
            { model | user = Nothing, pageState = Loaded Home } ! []

        ( MenuClick, _ ) ->
            { model | menuState = not model.menuState } ! []

        _ ->
            model ! []
