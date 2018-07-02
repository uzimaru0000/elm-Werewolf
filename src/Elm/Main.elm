module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (..)
import Update exposing (..)
import Auth.Sub as Auth exposing (..)
import RoomCreate.Sub as RoomCreate exposing (..)
import RoomListing.Sub as RoomListing exposing (..)
import Firebase exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route)
import Firebase exposing (..)


locateInit : Location -> ( Model, Cmd Msg )
locateInit loc =
    setRoute (Routing.parseLocation loc) init


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        NotFound ->
            Sub.none

        Login model ->
            Auth.subscriptions model |> Sub.map AuthMsg

        RoomListing model ->
            RoomListing.subscriptions model |> Sub.map RoomListingMsg

        RoomCreate model ->
            RoomCreate.subscriptions model |> Sub.map RoomCreateMsg


subscriptions : Model -> Sub Msg
subscriptions model =
    [ getPage model.pageState
        |> pageSubscriptions
    , getRoomListDate RoomListingInit
    ]
        |> Sub.batch


main : Program Never Model Msg
main =
    Navigation.program LocationChange
        { init = locateInit
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
