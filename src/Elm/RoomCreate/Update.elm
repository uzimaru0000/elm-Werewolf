module RoomCreate.Update exposing (..)

import RoomCreate.Model exposing (..)
import Firebase exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputName str ->
            { model | roomName = Just str } ! []

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

        Create ->
            model ! [ createRoom () ]
