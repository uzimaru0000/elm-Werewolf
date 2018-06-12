module RoomListing.Update exposing (..)

import RoomListing.Model exposing (..)
import Firebase exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListRequest ->
            model ! [ listRequest () ]
        GetList list ->
            { model | roomList = list, isLoading = Just False } ! []
        LoadStart _ ->
            { model | isLoading = Just True } ! []
        
