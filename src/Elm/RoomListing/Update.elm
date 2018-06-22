module RoomListing.Update exposing (..)

import RoomListing.Model exposing (..)
import Firebase exposing (..)
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
                        { model | roomList = list, isLoading = Just False } ! []
                    
                    Err _ ->
                        model ! []

        LoadStart _ ->
            { model | isLoading = Just True } ! []
