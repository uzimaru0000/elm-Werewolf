module RoomListing.Update exposing (..)

import RoomListing.Model exposing (..)
import Firebase exposing (..)
import Dict exposing (..)
import Json.Decode as Json
import Room exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListRequest ->
            model ! [ listRequest () ]

        GetList list ->
            { model | roomList = list, isLoading = Just False } ! [ usersRequest () ]

        GetUserList list ->
            let
                newDict =
                    list
                        |> List.foldl (\x acc -> Dict.insert x.uid x acc) model.userDict
            in
                { model | userDict = newDict } ! []

        LoadStart _ ->
            { model | isLoading = Just True } ! []

        InputRoomName str ->
            { model
                | serchRoomName =
                    if String.isEmpty str then
                        Nothing
                    else
                        Just str
            }
                ! []

        CheckRule rule ->
            let
                newList =
                    if List.member rule model.checkedRules then
                        List.filter ((/=) rule) model.checkedRules
                    else
                        rule :: model.checkedRules
            in
                { model | checkedRules = newList } ! []
