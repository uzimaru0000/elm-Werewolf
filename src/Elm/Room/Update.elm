module Room.Update exposing (..)

import Firebase exposing (..)
import Room exposing (..)
import Room.Model exposing (..)
import Json.Decode as JD
import Navigation
import Routing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ room, user } as model) =
    case msg of
        Exit ->
            model
                ! [ exitRoom <| roomEncoder room
                  , Navigation.newUrl <| Routing.routeToUrl Routing.RoomListing
                  ]

        FetchRoomInfo value ->
            let
                maybeRoom =
                    JD.decodeValue roomDecoder value
                        |> Result.toMaybe
            in
                case maybeRoom of
                    Just room ->
                        { model | room = room } ! []

                    Nothing ->
                        model ! []

        ModalOff ->
            model ! [ Navigation.newUrl <| Routing.routeToUrl Routing.RoomListing ]

        InputPass str ->
            { model | input = str } ! []

        Join _ ->
            let
                isSuccess =
                    room.pass == model.input
            in
                { model | isAuth = isSuccess, passwordError = not isSuccess } ! []
