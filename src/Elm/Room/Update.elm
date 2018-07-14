module Room.Update exposing (..)

import Firebase exposing (..)
import Room exposing (..)
import Room.Model exposing (..)
import Json.Decode as JD


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ room, user } as model) =
    case msg of
        Join ->
            if model.input == room.pass then
                { model
                    | isActive = False
                    , passwordError = False
                    , input = ""
                }
                    ! [ joinRoom <| roomEncoder room ]
            else
                { model | passwordError = True } ! []

        Exit ->
            model ! [ exitRoom <| roomEncoder room ]

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

        PassWordInput str ->
            { model | input = str } ! []

        ModalStateChange flag ->
            { model
                | isActive = flag
                , passwordError = False
                , input = ""
            }
                ! []
