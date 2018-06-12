module View exposing (..)

import Model exposing (..)
import Auth.View as Auth exposing (..)
import RoomCreate.View as RoomCreate exposing (..)
import RoomListing.View as RoomListing exposing (..)
import RoomCreate.Model as RoomCreate
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div
        []
        [ Auth.view model.auth |> Html.map AuthMsg
        , div [ class "container" ]
            [ button
                [ class "button"
                , RoomCreateMsg RoomCreate.Activate |> onClick
                ]
                [ text "NewRoom" ]
            , RoomListing.view model.roomListing |> Html.map RoomListingMsg
            ]
        , RoomCreate.view model.roomCreate |> Html.map RoomCreateMsg
        ]
