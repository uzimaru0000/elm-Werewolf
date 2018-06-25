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
        , hero model
        , div [ class "container" ]
            [ page model
            ]
        ]


locateTab : Route -> Html Msg
locateTab route =
    [ RoomListing
    , RoomCreate
    ]
        |> List.map (\x -> ( x, locateString x ))
        |> List.map
            (\( r, str ) ->
                li
                    [ classList [ ( "is-active", r == route ) ]
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


hero : Model -> Html Msg
hero model =
    let
        titles =
            case model.route of
                RoomListing ->
                    ( "RoomList", "現在のすべてのルームです" )

                RoomCreate ->
                    ( "Createing Room", "ルームを作成します" )

                Login ->
                    ( "Login", "" )

                NotFound ->
                    ( "NotFound", "存在しないページです" )
    in
        section
            [ class "hero is-medium is-primary block" ]
            [ div
                [ class "hero-body" ]
                [ div
                    [ class "container" ]
                    [ h1
                        [ class "title" ]
                        [ text <| Tuple.first titles ]
                    , h2
                        [ class "subtitle" ]
                        [ text <| Tuple.second titles ]
                    ]
                ]
            , if model.route /= Login then
                div
                    [ class "hero-foot" ]
                    [ nav
                        [ class "tabs is-boxed is-fullwidth" ]
                        [ div
                            [ class "container" ]
                            [ locateTab model.route
                            ]
                        ]
                    ]
              else
                text ""
            ]


page : Model -> Html Msg
page model =
    case model.route of
        RoomListing ->
            RoomListing.view model.roomListing |> Html.map RoomListingMsg

        RoomCreate ->
            RoomCreate.view model.roomCreate |> Html.map RoomCreateMsg

        Login ->
            Auth.loginView model.auth |> Html.map AuthMsg

        _ ->
            text "not found"
