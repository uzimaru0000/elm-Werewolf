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

        GetList value ->
            let
                newList = Json.decodeValue (Json.list roomDecoder) value
            in
                case newList of
                    Ok list ->
                        { model | roomList = list, isLoading = Just False } ! [ usersRequest () ]
                    
                    Err _ ->
                        model ! []
                        
        GetUserList list ->
            let
                newDict =
                    list
                        |> List.foldl (\x acc -> Dict.insert x.uid x acc) model.userDict
            in
                { model | userDict = newDict } ! []

        LoadStart _ ->
            { model | isLoading = Just True } ! []
