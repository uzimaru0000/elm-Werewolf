module View exposing (..)

import Model exposing (..)
import User exposing (..)
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
            frame model.user page False

        Transition page ->
            frame model.user page True


frame : Maybe User -> Page -> Bool -> Html Msg
frame user currentPage isLoading =
    div
        []
        [ loading isLoading
        , page user currentPage
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


page : Maybe User -> Page -> Html Msg
page user page =
    case page of
        RoomListing model ->
            div []
                [ navbar user
                , hero page
                , RoomListing.view model |> Html.map RoomListingMsg
                ]

        RoomCreate model ->
            div []
                [ navbar user
                , hero page
                , RoomCreate.view model |> Html.map RoomCreateMsg
                ]

        Login ->
            div []
                [ navbar user
                , Auth.view |> Html.map AuthMsg
                ]

        _ ->
            text "not found"


navbar : Maybe User -> Html Msg
navbar user =
    nav
        [ class "navbar"
        ]
        [ div [ class "navbar-brand" ]
            [ div [ class "navbar-item" ] [ text "WereWolf Online" ]
            , div
                [ class "navbar-burger"
                , classList [ ( "is-active", False ) ]
                ]
                [ span [] []
                , span [] []
                , span [] []
                ]
            ]
        , div
            [ class "navbar-menu"
            , classList [ ( "is-active", False ) ]
            ]
            [ navbarEnd user ]
        ]


navbarEnd : Maybe User -> Html Msg
navbarEnd user =
    div [ class "navbar-end" ]
        [ case user of
            Just user ->
                div
                    [ class "navbar-item has-dropdown"
                    , classList [ ( "is-active", False ) ]
                    ]
                    [ div
                        [ class "navbar-link is-dark is-hidden-touch"
                        ]
                        [ img
                            [ user.iconUrl |> Maybe.withDefault "" |> src
                            , style [ ( "border-radius", "50%" ) ]
                            ]
                            []
                        ]
                    , div
                        [ class "navbar-dropdown" ]
                        [ a
                            [ class "navbar-item  has-text-danger"
                            ]
                            [ text "logout" ]
                        ]
                    ]

            Nothing ->
                div
                    [ class "navbar-item" ]
                    [ div
                        [ class "field is-grouped" ]
                        [ div
                            [ class "control" ]
                            [ div
                                [ class "button"
                                , onClick <| RouteChange Routing.Login
                                ]
                                [ text "Login / Signin" ]
                            ]
                        ]
                    ]
        ]


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
