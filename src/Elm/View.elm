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
        , section
            [ class "hero is-medium is-primary block" ]
            [ div
                [ class "hero-body" ]
                [ div
                    [ class "container" ]
                    [ h1
                        [ class "title" ]
                        [ text "WereWolf Local" ]
                    , h2
                        [ class "subtitle" ]
                        [ text "this is sub title" ]
                    ]
                ]
            ]
        , div [ class "container" ]
            [ RoomListing.view model.roomListing |> Html.map RoomListingMsg
            ]
        , RoomCreate.view model.roomCreate |> Html.map RoomCreateMsg
        ]
