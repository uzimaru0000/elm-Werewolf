module RoomListing.Sub exposing (..)

import RoomListing.Model exposing (..)
import Firebase exposing (..)
import Room exposing (..)
import Json.Decode exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    [ (\x ->
        decodeValue (list roomDecoder) x
        |> Result.toMaybe
        |> Maybe.withDefault []
        |> GetList
      )
        |> getRoomList
    , loadingStart LoadStart
    , getUsers GetUserList
    ]
        |> Sub.batch
