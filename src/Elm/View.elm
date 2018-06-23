module View exposing (..)

import Model exposing (..)
import Routing exposing (..)
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
            , div
                [ class "hero-foot" ]
                [ nav
                    [ class "tabs is-boxed is-fullwidth" ]
                    [ div
                        [ class "container" ]
                        [ locateTab model.route
                        ]
                    ]
                ]
            ]
        , div [ class "container" ]
            [ page model
            ]
        ]


locateTab : Route -> Html Msg
locateTab route =
    [ RoomListing
    , RoomCreate
    ]
    |> List.map (\x -> (x, locateString x))
    |> List.map (\(r, str) -> 
        li
            [ classList [ ("is-active", r == route) ]
            ]
            [ a
                [ onClick <| RouteChange r ]
                [ text str ]
            ]
    )
    |> ul []


locateString : Route -> String
locateString route =
    case route of
        RoomListing ->
            "Rooms"
        RoomCreate ->
            "Create"
        _ ->
            ""


page : Model -> Html Msg
page model =
    case model.route of
        RoomListing ->
            RoomListing.view model.roomListing |> Html.map RoomListingMsg
        
        RoomCreate ->
            RoomCreate.view model.roomCreate |> Html.map RoomCreateMsg
        
        _ ->
            text "not found"