module Main exposing (..)

import Model exposing (..)
import User exposing (User)
import View exposing (..)
import Update exposing (..)
import RoomCreate.Sub as RoomCreate exposing (..)
import RoomListing.Sub as RoomListing exposing (..)
import Firebase exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route)
import Firebase exposing (..)


locateInit : Maybe User -> Location -> ( Model, Cmd Msg )
locateInit user loc =
    setRoute (Routing.parseLocation loc) { init | user = user }


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Login ->
            Sub.none

        RoomListing model ->
            RoomListing.subscriptions model |> Sub.map RoomListingMsg

        RoomCreate model ->
            RoomCreate.subscriptions model |> Sub.map RoomCreateMsg


subscriptions : Model -> Sub Msg
subscriptions model =
    [ getPage model.pageState
        |> pageSubscriptions
    , getRoomListDate RoomListingInit
    , logoutSuccess LogoutSuccess
    ]
        |> Sub.batch


main : Program (Maybe User) Model Msg
main =
    Navigation.programWithFlags LocationChange
        { init = locateInit
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
