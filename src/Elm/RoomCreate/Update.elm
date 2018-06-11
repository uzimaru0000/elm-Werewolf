module RoomCreate.Update exposing (..)

import RoomCreate.Model exposing (..)
import Firebase exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputName str ->
            { model
                | roomName = Just str
                , isInputError = String.isEmpty str
            }
                ! []

        InputNum str ->
            let
                num =
                    String.toInt str
                        |> Result.withDefault 5
            in
                { model | maxNum = num } ! []

        InputPass str ->
            { model
                | pass =
                    if String.isEmpty str then
                        Nothing
                    else
                        Just str
            }
                ! []

        Exit ->
            { model | isActive = False } ! []

        Create ->
            case model.roomName of
                Nothing ->
                    { model | roomName = Just "", isInputError = True } ! []
                Just _ ->
                    model ! [ createRoom model ]
