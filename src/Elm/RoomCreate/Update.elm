module RoomCreate.Update exposing (..)

import RoomCreate.Model exposing (..)
import Firebase exposing (..)
import Room exposing (..)
import Routing exposing (..)
import Navigation exposing (..)


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

        RuleActive rule ->
            let
                helper t ( r, n ) =
                    if r == t then
                        if n == 0 then
                            ( r, 1 )
                        else
                            ( r, 0 )
                    else
                        ( r, n )

                newSet =
                    model.ruleSet
                        |> List.map (helper rule)
            in
                { model | ruleSet = newSet } ! []

        InputRoleNum rule str ->
            let
                num =
                    String.toInt str
                        |> Result.toMaybe

                helper t n ( r, m ) =
                    if r == t then
                        ( r, n |> Maybe.withDefault m )
                    else
                        ( r, m )

                newSet =
                    model.ruleSet
                        |> List.map (helper rule num)
            in
                { model | ruleSet = newSet } ! []

        Create ->
            case model.roomName of
                Nothing ->
                    { model | roomName = Just "", isInputError = True } ! []

                Just str ->
                    if (not << String.isEmpty) str then
                        { model | isSuccess = Just False }
                            ! [ model
                                    |> modelToValue
                                    |> createRoom
                              ]
                    else
                        model ! []

        Success _ ->
            init ! [ Navigation.newUrl <| routeToUrl RoomListing ]
