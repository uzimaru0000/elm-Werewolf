module RoomListing.Update exposing (..)

import RoomListing.Model exposing (..)
import Firebase exposing (..)
import Dict exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListRequest ->
            model ! [ listRequest () ]

        GetList list ->
            { model | roomList = list, isLoading = Just False } ! [ usersRequest () ]

        LoadStart _ ->
            { model | isLoading = Just True } ! []

        GetUserList list ->
            let
                newDict =
                    list
                        |> List.foldl (\x acc -> Dict.insert x.uid x acc) model.userDict
            in
                { model | userDict = newDict } ! []
