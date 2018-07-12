module RoomCreate.Update exposing (..)

import RoomCreate.Model exposing (..)
import Firebase exposing (..)
import Routing exposing (..)
import Navigation exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputName str ->
            let
                newModel =
                    { model | roomName = Just str }
            in
                { newModel | errors = errorCheck newModel } ! []

        InputNum str ->
            let
                num =
                    String.toInt str
                        |> Result.withDefault 5
                
                newModel =
                    { model | maxNum = num }
            in
                { newModel | errors = errorCheck newModel } ! []

        InputPass str ->
            let
                newModel =
                    { model | pass = Just str }
            in
                { newModel | errors = errorCheck newModel } ! []

        RuleActive rule ->
            let
                helper t ( r, n ) =
                    if r == t then
                        if n < ruleMinNum r then
                            ( r, ruleMinNum r )
                        else
                            ( r, 0 )
                    else
                        ( r, n )

                newSet =
                    model.ruleSet
                        |> List.map (helper rule)

                newModel =
                    { model | ruleSet = newSet }
            in
                { newModel | errors = errorCheck newModel } ! []

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

                newModel =
                    { model | ruleSet = newSet }
            in
                { newModel | errors = errorCheck newModel } ! []

        Create ->
            { model | isSuccess = Just False }
                ! [ model
                        |> modelToValue
                        |> createRoom
                  ]

        Success _ ->
            model ! [ Navigation.newUrl <| routeToUrl RoomListing ]


errorCheck : Model -> Errors
errorCheck { roomName, pass, ruleSet, maxNum } =
    let
        nameMissing =
            case roomName of
                Just "" ->
                    True

                _ ->
                    False

        passMissing =
            case pass of
                Just "" ->
                    True

                _ ->
                    False

        memberMissing =
            ruleSet
                |> List.map Tuple.second
                |> List.foldl (+) 0
                |> (/=) maxNum
    in
        Errors nameMissing passMissing memberMissing
