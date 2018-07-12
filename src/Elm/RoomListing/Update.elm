module RoomListing.Update exposing (..)

import RoomListing.Model exposing (..)
import Navigation
import Routing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetList list ->
            { model | roomList = list } ! []

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

        MoveRoom uid ->
            model ! [ Navigation.newUrl <| Routing.routeToUrl <| Routing.Room uid ]