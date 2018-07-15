module RoomListing.Update exposing (..)

import RoomListing.Model exposing (..)
import Navigation
import Routing
import Firebase exposing (..)
import Room exposing (roomEncoder)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetList list ->
            { model | roomList = list } ! []

        Join uid ->
            case model.selectedRoom of
                Just room ->
                    if model.input == room.pass then
                        model
                            ! [ Navigation.newUrl <| Routing.routeToUrl <| Routing.Room uid
                              , joinRoom <| roomEncoder room
                              ]
                    else
                        { model | passwordError = True } ! []
                
                Nothing ->
                    model ! []

        SelectRoom room ->
            { model | selectedRoom = Just room } ! []

        InputPass str ->
            { model | input = str } ! []
        
        ModalOff ->
            { model | input = "", selectedRoom = Nothing, passwordError = False } ! []