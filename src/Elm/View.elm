module View exposing (..)

import Model exposing (..)
import User exposing (..)
import Routing exposing (Route)
import Auth.View as Auth exposing (..)
import RoomCreate.View as RoomCreate
import RoomListing.View as RoomListing
import Home.View as Home
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            frame model.user page False model.menuState

        Transition page ->
            frame model.user page True model.menuState


frame : Maybe User -> Page -> Bool -> Bool -> Html Msg
frame user currentPage isLoading isActive =
    div
        []
        [ loading isLoading
        , navbar isActive user
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

        Routing.Home ->
            "Home"

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

                Home ->
                    ( "Home", "Welcome to WereWolf" )

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
                [ hero page
                , RoomListing.view model |> Html.map RoomListingMsg
                ]

        RoomCreate model ->
            div []
                [ hero page
                , RoomCreate.view model |> Html.map RoomCreateMsg
                ]

        Login ->
            div []
                [ Auth.view |> Html.map AuthMsg
                ]

        Home ->
            div []
                [ Home.view
                ]

        _ ->
            text "not found"


navbar : Bool -> Maybe User -> Html Msg
navbar isActive user =
    nav
        [ class "navbar"
        ]
        [ div [ class "navbar-brand" ]
            [ a
                [ class "navbar-item"
                , onClick <| RouteChange Routing.Home
                ]
                [ text "WereWolf Online" ]
            , div
                [ class "navbar-burger"
                , classList [ ( "is-active", isActive ) ]
                , onClick MenuClick
                ]
                [ span [] []
                , span [] []
                , span [] []
                ]
            ]
        , div
            [ class "navbar-menu"
            , classList [ ( "is-active", isActive ) ]
            ]
            [ navbarEnd user ]
        ]


navbarEnd : Maybe User -> Html Msg
navbarEnd user =
    case user of
        Just user ->
            div [ class "navbar-end" ]
                [ div
                    [ class "navbar-item" ]
                    [ div
                        [ class "field is-grouped" ]
                        [ div
                            [ class "control" ]
                            [ div [ class "button is-white" ]
                                [ img
                                    [ user.iconUrl |> Maybe.withDefault "" |> src
                                    , style
                                        [ ( "border-radius", "50%" ) ]
                                    ]
                                    []
                                , span [] [ text user.name ]
                                ]
                            ]
                        , div
                            [ class "control" ]
                            [ div
                                [ class "button is-white"
                                , onClick Logout
                                ]
                                [ text "SignOut"
                                ]
                            ]
                        ]
                    ]
                ]

        Nothing ->
            div [ class "navbar-end" ]
                [ div
                    [ class "navbar-item" ]
                    [ div
                        [ class "field is-grouped" ]
                        [ div
                            [ class "control" ]
                            [ div
                                [ class "button is-white"
                                , onClick <| RouteChange Routing.Login
                                ]
                                [ text "SignUp / SignIn" ]
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
