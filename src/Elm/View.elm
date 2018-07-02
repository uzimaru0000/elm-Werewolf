module View exposing (..)

import Model exposing (..)
import Routing exposing (Route)
import Auth.View as Auth exposing (..)
import RoomCreate.View as RoomCreate exposing (..)
import RoomListing.View as RoomListing exposing (..)
import RoomCreate.Model as RoomCreate
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            frame page False

        Transition page ->
            frame page True


frame : Page -> Bool -> Html Msg
frame currentPage isLoading =
    div
        []
        [ loading (isLoading |> Debug.log "")
        , page currentPage
        ]


locateTab : Route -> Html Msg
locateTab route =
    [ Routing.RoomListing
    , Routing.RoomCreate
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
        Routing.RoomListing ->
            "Rooms"

        Routing.RoomCreate ->
            "Create"

        _ ->
            ""


hero : Page -> Html Msg
hero page =
    let
        titles =
            case page of
                RoomListing _ ->
                    ( "RoomList", "現在のすべてのルームです" )

                RoomCreate _ ->
                    ( "Createing Room", "ルームを作成します" )

                _ ->
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
            , div
                [ class "hero-foot" ]
                [ nav
                    [ class "tabs is-boxed is-fullwidth" ]
                    [ div
                        [ class "container" ]
                        [ locateTab <| pageToRoute page
                        ]
                    ]
                ]
            ]


page : Page -> Html Msg
page page =
    case page of
        RoomListing model ->
            div []
                [ hero page
                , RoomListing.view model |> Html.map RoomListingMsg
                ]

        RoomCreate model ->
            div []
                [ hero page
                , RoomCreate.view model |> Html.map RoomCreateMsg
                ]

        _ ->
            text "not found"


loading : Bool -> Html Msg
loading isLoading =
    div
        [ classList
            [ ( "is-inactive", not isLoading )
            , ( "loading", True )
            , ( "has-background-info", True )
            ]
        ]
        [ div
            [ class "sk-double-bounce" ]
            [ div [ class "sk-child sk-double-bounce1" ] []
            , div [ class "sk-child sk-double-bounce2" ] []
            ]
        ]
