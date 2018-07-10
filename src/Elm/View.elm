module View exposing (..)

import Model exposing (..)
import User exposing (..)
import Routing exposing (Route)
import Auth.View as Auth exposing (..)
import RoomCreate.View as RoomCreate
import RoomListing.View as RoomListing
import Home.View as Home
import Html exposing (Html, div, text, span, img, p, a)
import Html.Attributes exposing (class, classList, style, src, href, target)
import Html.Events exposing (onClick)
import Bulma.Layout exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography as Typo
import Bulma.Elements exposing (..)
import Bulma.Components exposing (..)


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
        , navigation isActive user
        , page user currentPage
        ]


locateTab : Route -> List (Tab Msg)
locateTab route =
    [ Routing.RoomListing
    , Routing.RoomCreate
    ]
        |> List.map (\x -> ( x, locateString x ))
        |> List.map (\( r, str ) -> tab (r == route) [] [ onClick <| RouteChange r ] [ text str ])


locateString : Route -> String
locateString route =
    case route of
        Routing.RoomListing ->
            "Rooms"

        Routing.RoomCreate ->
            "Create"

        _ ->
            ""


header : Page -> Html Msg
header page =
    let
        ( heroTitle, subTitle ) =
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
        hero
            { heroModifiers
                | size = Standard
                , color = Primary
            }
            [ display Block ]
            [ heroBody []
                [ container
                    []
                    [ title H3 [] [ text heroTitle ]
                    , subtitle H5 [] [ text subTitle ]
                    ]
                ]
            , heroFoot []
                [ container
                    []
                    [ pageToRoute page
                        |> locateTab
                        |> tabs
                            { tabsModifiers
                                | style = Boxed
                            }
                            [ fullWidth ]
                            []
                    ]
                ]
            ]


page : Maybe User -> Page -> Html Msg
page user page =
    case page of
        RoomListing model ->
            div []
                [ header page
                , RoomListing.view model |> Html.map RoomListingMsg
                , myFooter
                ]

        RoomCreate model ->
            div []
                [ header page
                , RoomCreate.view model |> Html.map RoomCreateMsg
                ]

        Login ->
            div []
                [ Auth.view |> Html.map AuthMsg
                ]

        Home ->
            div []
                [ Home.view
                , myFooter
                ]

        _ ->
            text "not found"


navigation : Bool -> Maybe User -> Html Msg
navigation isActive user =
    navbar navbarModifiers
        []
        [ navbarBrand []
            (navbarBurger isActive
                [ onClick MenuClick ]
                [ span [] []
                , span [] []
                , span [] []
                ]
            )
            [ navbarItemLink False
                [ onClick <| RouteChange Routing.RoomListing ]
                [ text "WereWolf Online" ]
            ]
        , navbarMenu isActive
            []
            [ navigationEnd user ]
        ]


navigationEnd : Maybe User -> Html Msg
navigationEnd maybeUser =
    case maybeUser of
        Just user ->
            navbarEnd []
                [ navbarItemLink False
                    []
                    [ image (OneByOne X24)
                        []
                        [ img
                            [ user.iconUrl |> Maybe.withDefault "" |> src ]
                            []
                        ]
                    , span [] [ text user.name ]
                    ]
                , navbarItemLink False
                    [ onClick Logout
                    , Typo.textColor Typo.Danger
                    ]
                    [ text "SignOut" ]
                ]

        Nothing ->
            navbarEnd []
                [ navbarItemLink False
                    [ onClick <| RouteChange Routing.Login ]
                    [ text "SignUp / SignIn" ]
                ]


myFooter : Html Msg
myFooter =
    footer []
        [ container []
            [ content Small
                [ Typo.textCentered ]
                [ a
                    [ href "https://github.com/uzimaru0000/elm-Werewolf"
                    , target "_blank"
                    ]
                    [ text "Please give this site star." ]
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
